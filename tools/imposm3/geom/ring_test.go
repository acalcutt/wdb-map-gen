package geom

import (
	"sort"
	"testing"

	osm "github.com/omniscale/go-osm"
)

func TestRingMerge(t *testing.T) {
	w1 := osm.Way{}
	w1.ID = 1
	w1.Refs = []int64{1, 2, 3}
	w1.Nodes = []osm.Node{
		osm.Node{},
		osm.Node{},
		osm.Node{},
	}
	r1 := newRing(&w1)

	w2 := osm.Way{}
	w2.ID = 2
	w2.Refs = []int64{3, 4, 1}
	w2.Nodes = []osm.Node{
		osm.Node{},
		osm.Node{},
		osm.Node{},
	}
	r2 := newRing(&w2)
	rings := []*ring{r1, r2}

	result := mergeRings(rings)
	if len(result) != 1 {
		t.Fatal(result)
	}
	r := result[0]
	expected := []int64{1, 2, 3, 4, 1}
	for i, ref := range r.refs {
		if ref != expected[i] {
			t.Fatalf("%v != %v", r.refs, expected)
		}
	}
}

func TestRingMergeMissingRefs(t *testing.T) {
	// way without refs should not panic with index out of range
	w1 := osm.Way{}
	w1.ID = 1
	w1.Refs = []int64{1, 2, 3}
	w1.Nodes = []osm.Node{
		osm.Node{},
		osm.Node{},
		osm.Node{},
	}
	r1 := newRing(&w1)

	w2 := osm.Way{}
	w2.ID = 2
	w2.Refs = []int64{}
	w2.Nodes = []osm.Node{}
	r2 := newRing(&w2)
	rings := []*ring{r1, r2}

	result := mergeRings(rings)
	if len(result) != 1 {
		t.Fatal(result)
	}
	if result[0] != r1 {
		t.Fatal(result[0])
	}
}

func TestRingMergeReverseEndpoints(t *testing.T) {
	w1 := osm.Way{}
	w1.ID = 1
	w1.Refs = []int64{1, 2, 3, 4}
	w1.Nodes = []osm.Node{
		osm.Node{},
		osm.Node{},
		osm.Node{},
		osm.Node{},
	}
	r1 := newRing(&w1)

	w2 := osm.Way{}
	w2.ID = 2
	w2.Refs = []int64{6, 5, 4}
	w2.Nodes = []osm.Node{
		osm.Node{},
		osm.Node{},
		osm.Node{},
	}
	r2 := newRing(&w2)

	w3 := osm.Way{}
	w3.ID = 3
	w3.Refs = []int64{1, 7, 6}
	w3.Nodes = []osm.Node{
		osm.Node{},
		osm.Node{},
		osm.Node{},
	}
	r3 := newRing(&w3)

	rings := []*ring{r1, r2, r3}

	result := mergeRings(rings)
	if len(result) != 1 {
		t.Fatal(result)
	}
	r := result[0]
	expected := []int64{6, 5, 4, 3, 2, 1, 7, 6}
	for i, ref := range r.refs {
		if ref != expected[i] {
			t.Fatalf("%v != %v", r.refs, expected)
		}
	}
}

func TestRingMergePermutations(t *testing.T) {
	// Test all possible permutations of 4 ring segments.
	for i := 0; i < 16; i++ {
		// test each segment in both directions
		f1 := i&1 == 0
		f2 := i&2 == 0
		f3 := i&4 == 0
		f4 := i&8 == 0

		indices := []int{0, 1, 2, 3}

		for permutationFirst(sort.IntSlice(indices)); permutationNext(sort.IntSlice(indices)); {
			ways := make([][]int64, 4)
			if f1 {
				ways[0] = []int64{1, 2, 3, 4}
			} else {
				ways[0] = []int64{4, 3, 2, 1}
			}
			if f2 {
				ways[1] = []int64{4, 5, 6, 7}
			} else {
				ways[1] = []int64{7, 6, 5, 4}
			}
			if f3 {
				ways[2] = []int64{7, 8, 9, 10}
			} else {
				ways[2] = []int64{10, 9, 8, 7}
			}
			if f4 {
				ways[3] = []int64{10, 11, 12, 1}
			} else {
				ways[3] = []int64{1, 12, 11, 10}
			}

			w1 := osm.Way{}
			w1.ID = 1
			w1.Refs = ways[indices[0]]
			w1.Nodes = []osm.Node{osm.Node{}, osm.Node{}, osm.Node{}, osm.Node{}}
			w2 := osm.Way{}
			w2.ID = 2
			w2.Refs = ways[indices[1]]
			w2.Nodes = []osm.Node{osm.Node{}, osm.Node{}, osm.Node{}, osm.Node{}}
			w3 := osm.Way{}
			w3.ID = 3
			w3.Refs = ways[indices[2]]
			w3.Nodes = []osm.Node{osm.Node{}, osm.Node{}, osm.Node{}, osm.Node{}}
			w4 := osm.Way{}
			w4.ID = 4
			w4.Refs = ways[indices[3]]
			w4.Nodes = []osm.Node{osm.Node{}, osm.Node{}, osm.Node{}, osm.Node{}}

			rings := []*ring{
				&ring{ways: []*osm.Way{&w1}, refs: w1.Refs, nodes: w1.Nodes},
				&ring{ways: []*osm.Way{&w2}, refs: w2.Refs, nodes: w2.Nodes},
				&ring{ways: []*osm.Way{&w3}, refs: w3.Refs, nodes: w3.Nodes},
				&ring{ways: []*osm.Way{&w4}, refs: w4.Refs, nodes: w4.Nodes},
			}
			result := mergeRings(rings)
			if len(result) != 1 {
				t.Fatalf("not a single ring: %v\n", result)
			}

			r := result[0].refs

			if r[0] != r[len(r)-1] {
				t.Fatalf("ring not closed: %v", r)
			}

			asc := true
			desc := true

			for i := 1; i < len(r); i++ {
				if r[i] == 1 || r[i-1] < r[i] {
					continue
				} else {
					asc = false
					break
				}
			}
			for i := 1; i < len(r); i++ {
				if r[i] == 12 || r[i-1] > r[i] {
					continue
				} else {
					desc = false
					break
				}
			}

			if !(asc || desc) {
				t.Fatalf("ring not ascending/descending: %v, asc: %v, desc: %v", r, asc, desc)
			}
		}
	}
}

// Copyright (c) 2011 CZ.NIC z.s.p.o. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// blame: jnml, labs.nic.cz

// Generate the first permutation of data.
func permutationFirst(data sort.Interface) {
	sort.Sort(data)
}

// Generate the next permutation of data if possible and return true.
// If there is no more permutation left return false.
// Based on the algorithm described here:
// http://en.wikipedia.org/wiki/Permutation#Generation_in_lexicographic_order
func permutationNext(data sort.Interface) bool {
	var k, l int
	for k = data.Len() - 2; ; k-- { // 1.
		if k < 0 {
			return false
		}

		if data.Less(k, k+1) {
			break
		}
	}
	for l = data.Len() - 1; !data.Less(k, l); l-- { // 2.
	}
	data.Swap(k, l)                             // 3.
	for i, j := k+1, data.Len()-1; i < j; i++ { // 4.
		data.Swap(i, j)
		j--
	}
	return true
}
