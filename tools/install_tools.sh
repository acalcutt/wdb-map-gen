#install basics
read -p "Install Basics? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes update
	apt-get --assume-yes install build-essential ca-certificates lsb-release wget curl nano screen git sudo
fi

# Python Python-3 with pip
read -p "Install Python Python-3 with pip? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install zlib1g-dev libssl-dev libffi-dev python3 python3-pip python3-openssl
fi

#Install planetiler
read -p "Install planetiler? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -R planetiler
	apt-get install openjdk-21-jdk
	git clone --recurse-submodules https://github.com/onthegomap/planetiler.git
	cd planetiler
	git checkout a74f274c3162cd547c9b19a9a5e8705982a61755
	./scripts/build.sh
	cd ..
fi

#Install label_centerlines
read -p "Install label_centerlines? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	git clone https://github.com/acalcutt/label_centerlines.git
	cd label_centerlines
	pip install -r requirements.txt
	python3 setup.py install
	cd ..
fi

# Posgresql 16
read -p "Install Posgresql 16? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
	apt-get update
	apt-get --assume-yes install postgresql-16 postgresql-server-dev-16
	systemctl enable postgresql
	export PATH="/usr/lib/postgresql/15/bin:$PATH"
fi

#openmaptiles + openmaptiles-tools
read -p "Install openmaptiles + openmaptiles-tools? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# openmaptiles-tools install
	apt-get --assume-yes install graphviz sqlite3 aria2 osmctools
	python3 -m pip install git+https://github.com/openmaptiles/openmaptiles-tools@v6.1.4
	# openmaptiles
	git clone https://github.com/openmaptiles/openmaptiles.git
	cd openmaptiles
	git checkout tags/v3.13
	cd ..
fi

# osml10n Postgres extension
read -p "Install osml10n Postgres extension? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install devscripts equivs libicu-dev postgresql-server-dev-all libkakasi2-dev libutf8proc-dev pandoc
	git clone https://github.com/openmaptiles/mapnik-german-l10n.git
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
	apt-get --assume-yes install build-essential zlib1g-dev postgresql-server-dev-all pkg-config fakeroot devscripts
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
	apt-get --assume-yes install cmake
	wget http://download.osgeo.org/geos/geos-3.10.2.tar.bz2
	tar -xvf geos-3.10.2.tar.bz2
	cd geos-3.10.2
	chmod +x configure
	./configure
	make -j
	make install
	cd ..
	ldconfig
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
	ldconfig
	cd ..
fi

#Install Apache Arrow
read -p "Install Apache Arrow? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	wget https://apache.jfrog.io/artifactory/arrow/$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
	apt install -y -V ./apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb
	apt update
	apt install -y -V libarrow-dev # For C++
	apt install -y -V libarrow-glib-dev # For GLib (C)
	apt install -y -V libarrow-dataset-dev # For Apache Arrow Dataset C++
	apt install -y -V libarrow-dataset-glib-dev # For Apache Arrow Dataset GLib (C)
	apt install -y -V libarrow-acero-dev # For Apache Arrow Acero
	apt install -y -V libarrow-flight-dev # For Apache Arrow Flight C++
	apt install -y -V libarrow-flight-glib-dev # For Apache Arrow Flight GLib (C)
	apt install -y -V libgandiva-dev # For Gandiva C++
	apt install -y -V libgandiva-glib-dev # For Gandiva GLib (C)
	apt install -y -V libparquet-dev # For Apache Parquet C++
	apt install -y -V libparquet-glib-dev # For Apache Parquet GLib (C)
fi

#Install gdal
read -p "Install gdal? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	rm -rf gdal-3.8.4
	apt-get --assume-yes install libsqlite3-dev libspatialite-dev libkml-dev libgeotiff-dev
	wget https://github.com/OSGeo/gdal/releases/download/v3.8.4/gdal-3.8.4.tar.gz
	tar -xvf gdal-3.8.4.tar.gz
	cd gdal-3.8.4
	mkdir build
	cd build
	cmake ..
	cmake --build .
	cmake --build . --target install
	cd ..
	cd ..
	#Fix for (ogr2ogr: error while loading shared libraries: libgdal.so.27: cannot open shared object file: No such file or directory)
	ldconfig
fi

# postgis
read -p "Install postgis? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install libxml2-dev libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler libsfcgal-dev
	wget https://download.osgeo.org/postgis/source/postgis-3.4.2.tar.gz
	tar -xvf postgis-3.4.2.tar.gz
	cd postgis-3.4.2
	chmod +x configure
	./configure --with-sfcgal=/usr/bin/sfcgal-config
	make
	make install
	cd ..
fi

#Install Imposm
read -p "Install Imposm? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	wget https://github.com/omniscale/imposm3/releases/download/v0.11.1/imposm-0.11.1-linux-x86-64.tar.gz
	tar -xvf imposm-0.11.1-linux-x86-64.tar.gz
	rm -Rf imposm3/
	mkdir imposm3/
	mv imposm-0.11.1-linux-x86-64/ imposm3/bin/
fi

#Install libosmium (needed by osmborder)
read -p "Install libosmium? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	apt-get --assume-yes install libbz2-dev liblz4-dev libprotozero-dev libboost-tools-dev libboost-thread-dev cmake clang-tidy 
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
