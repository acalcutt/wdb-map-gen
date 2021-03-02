#install basics
read -p "Install Basics? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes update
	apt-get --assume-yes install build-essential wget curl nano screen git sudo
fi

# Python Python-3 with pip
read -p "Install Python Python-3 with pip? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install zlib1g-dev libssl-dev libffi-dev python3 python3-pip python3-openssl
fi

# Posgresql 13
read -p "Install Posgresql 13? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
	
	apt-get --assume-yes install postgresql-13 postgresql-server-dev-13
	systemctl enable postgresql
	export PATH="/usr/lib/postgresql/13/bin:$PATH"
fi

#openmaptiles + openmaptiles-tools
read -p "Install openmaptiles + openmaptiles-tools? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# openmaptiles-tools install
	apt-get install graphviz sqlite3 aria2 osmctools
	python3 -m pip install git+https://github.com/openmaptiles/openmaptiles-tools@v5.3.2
	# openmaptiles
	git clone --branch v3.12.1 https://github.com/openmaptiles/openmaptiles.git
fi

# osml10n Postgres extension
read -p "Install osml10n Postgres extension? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install devscripts equivs libicu-dev postgresql-server-dev-all libkakasi2-dev libutf8proc-dev pandoc
	git clone https://github.com/giggls/mapnik-german-l10n.git
	cd mapnik-german-l10n
	make
	make install
	cd ..
fi

# pgsql Postgres extension
read -p "Install pgsql Postgres extension? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	git clone https://github.com/pramsey/pgsql-gzip.git
	apt-get --assume-yes   install build-essential zlib1g-dev postgresql-server-dev-all pkg-config fakeroot devscripts
	cd pgsql-gzip
	make
	make install
	cd ..
fi

# GEOS
read -p "Install GEOS? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	wget http://download.osgeo.org/geos/geos-3.9.1.tar.bz2
	tar -xvf geos-3.9.1.tar.bz2
	cd geos-3.9.1
	chmod +x configure
	./configure
	make -j
	make install
	cd ..
fi

#Install proj
read -p "Install proj? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install sqlite3 libsqlite3-dev libtiff-dev libcurl4-openssl-dev pkg-config
	wget https://download.osgeo.org/proj/proj-7.2.1.tar.gz
	tar -xvf proj-7.2.1.tar.gz
	cd proj-7.2.1
	chmod +x configure
	./configure
	make
	make install
	ln -s /usr/local/lib/libproj.so.19 /usr/lib/libproj.so.19
	ln -s /usr/local/lib/libproj.so.19.1.1 /usr/lib/libproj.so.19.1.1
	cd ..
fi

#Install gdal
read -p "Install gdal? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes   install libsqlite3-dev libspatialite-dev
	wget https://github.com/OSGeo/gdal/releases/download/v3.2.1/gdal-3.2.1.tar.gz
	tar -xvf gdal-3.2.1.tar.gz
	cd gdal-3.2.1
	chmod +x configure
	./configure --with-proj=/usr/local --with-spatialite
	make
	make install
	#Fix for (ogr2ogr: error while loading shared libraries: libgdal.so.27: cannot open shared object file: No such file or directory)
	ln -s /usr/local/lib/libgdal.so.27.0.3 /usr/lib/libgdal.so.27.0.3
	ln -s /usr/local/lib/libgdal.so /usr/lib/libgdal.so
	ln -s /usr/local/lib/libgdal.so.27 /usr/lib/libgdal.so.27
	ln -s /usr/local/lib/libgdal.so.28 /usr/lib/libgdal.so.28
	cd ..
fi

# postgis
read -p "Install postgis? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install libxml2-dev libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler
	wget https://download.osgeo.org/postgis/source/postgis-3.1.1.tar.gz
	tar -xvf postgis-3.1.1.tar.gz
	cd postgis-3.1.1
	chmod +x configure
	./configure
	make
	make install
	cd ..
fi

#go
read -p "Install go? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz
	tar -xvf go1.15.2.linux-amd64.tar.gz
	cp -r go /usr/local
fi

#Leveldb
read -p "Install Leveldb? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	wget https://github.com/google/leveldb/archive/v1.19.tar.gz
	tar -xvf v1.19.tar.gz
	cd leveldb-1.19/
	make
	scp out-static/lib* out-shared/lib* /usr/local/lib/
	cd include/
	scp -r leveldb /usr/local/include/
	cd ..
	cd ..
fi

#Imposm
read -p "Install Imposm? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -Rf imposm3
	mkdir -p imposm3
	cd imposm3
	export GOPATH=`pwd`
	../go/bin/go get github.com/omniscale/imposm3
	../go/bin/go install github.com/omniscale/imposm3/cmd/imposm
	cd ..
fi

#Install libosmium (needed by osmborder)
read -p "Install libosmium? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install libbz2-dev libprotozero-dev libboost-tools-dev libboost-thread-dev cmake clang-tidy 
	git clone https://github.com/osmcode/libosmium.git
	cd libosmium
	mkdir build
	cd build
	cmake ..
	make
	make install
	cd ..
	cd ..
fi

#Install osmborder
read -p "Install osmboarder? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	git clone https://github.com/pnorman/osmborder.git
	cd osmborder
	mkdir build
	cd build
	cmake ..
	make
	make install
fi

#Install tile-live
read -p "Install nvm and tile-live? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	nvm install v8.15.0
	nvm use v8.15.0
	#tile-copy
	npm install --unsafe-perm -g  tl mapnik@^3.7.2 @mapbox/mbtiles @mapbox/tilelive @mapbox/tilelive-vector @mapbox/tilelive-bridge @mapbox/tilelive-mapnik git+https://github.com/acalcutt/tilelive-tmsource.git
fi

#Install pgfutter
read -p "Install pgfutter? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	mkdir pgfutter
	cd pgfutter
	wget -O pgfutter https://github.com/lukasmartinelli/pgfutter/releases/download/v1.1/pgfutter_linux_amd64
	chmod +x pgfutter
	cd ..
fi