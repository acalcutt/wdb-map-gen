package test

import (
	"database/sql"
	"io/ioutil"
	"math"
	"os"
	"testing"

	"github.com/omniscale/imposm3/geom/geos"
)

func TestRouteRelation(t *testing.T) {
	if testing.Short() {
		t.Skip("system test skipped with -test.short")
	}
	t.Parallel()

	ts := importTestSuite{
		name: "route_relation",
	}

	t.Run("Prepare", func(t *testing.T) {
		var err error

		ts.dir, err = ioutil.TempDir("", "imposm_test")
		if err != nil {
			t.Fatal(err)
		}
		ts.config = importConfig{
			connection:      "postgis://",
			cacheDir:        ts.dir,
			osmFileName:     "build/route_relation.pbf",
			mappingFileName: "route_relation_mapping.yml",
		}
		ts.g = geos.NewGeos()

		ts.db, err = sql.Open("postgres", "sslmode=disable")
		if err != nil {
			t.Fatal(err)
		}
		ts.dropSchemas()
	})

	t.Run("Import", func(t *testing.T) {
		if ts.tableExists(t, ts.dbschemaImport(), "osm_routes") != false {
			t.Fatalf("table osm_routes exists in schema %s", ts.dbschemaImport())
		}
		ts.importOsm(t)
		if ts.tableExists(t, ts.dbschemaImport(), "osm_routes") != true {
			t.Fatalf("table osm_routes does not exists in schema %s", ts.dbschemaImport())
		}
	})

	t.Run("Deploy", func(t *testing.T) {
		ts.deployOsm(t)
		if ts.tableExists(t, ts.dbschemaImport(), "osm_routes") != false {
			t.Fatalf("table osm_routes exists in schema %s", ts.dbschemaImport())
		}
		if ts.tableExists(t, ts.dbschemaProduction(), "osm_routes") != true {
			t.Fatalf("table osm_routes does not exists in schema %s", ts.dbschemaProduction())
		}
	})

	t.Run("RelationData", func(t *testing.T) {
		// check tags of relation
		r := ts.queryTags(t, "osm_routes", -100901)
		if r.tags["name"] != "Bus 301: A => B" {
			t.Error(r)
		}

		// check tags of master relation
		r = ts.queryTags(t, "osm_routes", -100911)
		if r.tags["name"] != "Bus 301" {
			t.Error(r)
		}
	})

	t.Run("MemberUpdatedByNode1", func(t *testing.T) {
		// check that member is updated after node was modified
		rows := ts.queryDynamic(t, "osm_route_members", "osm_id = -110901 AND member = 110101")
		if len(rows) != 1 {
			t.Fatal(rows)
		}
		if rows[0]["name"] != "Stop" {
			t.Error(rows[0])
		}
	})

	t.Run("MemberGeomUpdated1", func(t *testing.T) {
		rows := ts.queryDynamic(t, "osm_route_members", "osm_id = -100902 AND member = 100502")
		if len(rows) != 1 {
			t.Fatal(rows)
		}
		g := ts.g.FromWkt(rows[0]["wkt"])
		if math.Abs(g.Length()-111.32448543701321) > 0.00000001 {
			t.Fatal(g.Length())
		}

		rows = ts.queryDynamic(t, "osm_route_members", "osm_id = -100902 AND member = 100503")
		if len(rows) != 1 {
			t.Fatal(rows)
		}
		if rows[0]["name"] != "" {
			t.Error(rows[0])
		}
	})

	t.Run("NoRouteWithMissingMember", func(t *testing.T) {
		// current implementation: route members are all or nothing.
		// if one member is missing, no member is imported
		if r := ts.queryDynamic(t, "osm_route_members", "osm_id = -120901 AND member = 120101"); len(r) > 0 {
			t.Error("found member from route with missing members")
		}
	})

	// #######################################################################

	t.Run("Update", func(t *testing.T) {
		ts.updateOsm(t, "build/route_relation.osc.gz")
	})

	// #######################################################################

	t.Run("MemberGeomUpdated2", func(t *testing.T) {
		rows := ts.queryDynamic(t, "osm_route_members", "osm_id = -100902 AND member = 100502")
		if len(rows) != 1 {
			t.Fatal(rows)
		}
		g := ts.g.FromWkt(rows[0]["wkt"])
		if math.Abs(g.Length()-184.97560221624542) > 0.00000001 {
			t.Fatal(g.Length())
		}

		// tag from member is updated
		rows = ts.queryDynamic(t, "osm_route_members", "osm_id = -100902 AND member = 100503")
		if len(rows) != 1 {
			t.Fatal(rows)
		}
		if rows[0]["name"] != "new name" {
			t.Error(rows[0])
		}

		// member is removed
		rows = ts.queryDynamic(t, "osm_route_members", "osm_id = -100902 AND member = 100512")
		if len(rows) != 0 {
			t.Fatal(rows)
		}

		// role from member is updated
		rows = ts.queryDynamic(t, "osm_route_members", "osm_id = -100902 AND member = 100102")
		if len(rows) != 1 {
			t.Fatal(rows)
		}
		if rows[0]["role"] != "halt" {
			t.Error(rows[0])
		}

	})

	t.Run("MemberUpdatedByNode2", func(t *testing.T) {
		// check that member is updated after node was modified
		rows := ts.queryDynamic(t, "osm_route_members", "osm_id = -110901 AND member = 110101")
		if len(rows) != 1 {
			t.Fatal(rows)
		}
		if rows[0]["name"] != "Stop2" {
			t.Error(rows[0])
		}
	})

	t.Run("Cleanup", func(t *testing.T) {
		ts.dropSchemas()
		if err := os.RemoveAll(ts.dir); err != nil {
			t.Error(err)
		}
	})
}
