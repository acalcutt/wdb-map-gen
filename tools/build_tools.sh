# Python Python-3 with pip
apt-get install zlib1g-dev libssl-dev libffi-dev curl wget python3 python3-pip
export PATH="/usr/lib/postgresql/13/bin:$PATH"

# openmaptiles-tools install
apt-get install graphviz sqlite3 aria2 osmctools git
cd openmaptiles-tools
chmod +x *.sh
python3 -m pip install -r requirements.txt
cd ..

# Posgresql 13
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
apt-get update
apt-get install postgresql-13 postgresql-server-dev-13
systemctl enable postgresql

# osml10n Postgres extension
#git clone https://github.com/giggls/mapnik-german-l10n.git
sudo apt-get install devscripts equivs libicu-dev postgresql-server-dev-all libkakasi2-dev libutf8proc-dev pandoc
cd mapnik-german-l10n
chmod +x *.sh
make
make install
cd ..

#git clone https://github.com/pramsey/pgsql-gzip.git
sudo apt-get install build-essential zlib1g-dev postgresql-server-dev-all pkg-config fakeroot devscripts
cd pgsql-gzip
make
make install
cd ..

# GEOS
#wget http://download.osgeo.org/geos/geos-3.9.1.tar.bz2
#tar -xvf geos-3.9.1.tar.bz2
cd geos-3.9.1
./configure
make -j
make install
cd ..

#Install proj
apt-get install sqlite3 libsqlite3-dev libtiff-dev libcurl4-openssl-dev pkg-config
#wget https://download.osgeo.org/proj/proj-7.2.1.tar.gz
#tar -xvf proj-7.2.1.tar.gz
cd proj-7.2.1
./configure
make
make install
ln -s /usr/local/lib/libproj.so.19 /usr/lib/libproj.so.19
ln -s /usr/local/lib/libproj.so.19.1.1 /usr/lib/libproj.so.19.1.1
cd ..

#Install gdal
apt-get install libsqlite3-dev libspatialite-dev
#wget https://github.com/OSGeo/gdal/releases/download/v3.2.1/gdal-3.2.1.tar.gz
#tar -xvf gdal-3.2.1.tar.gz
cd gdal-3.2.1
./configure --with-proj=/usr/local --with-spatialite
make
make install
#Fix for (ogr2ogr: error while loading shared libraries: libgdal.so.27: cannot open shared object file: No such file or directory)
ln -s /usr/local/lib/libgdal.so.27.0.3 /usr/lib/libgdal.so.27.0.3
ln -s /usr/local/lib/libgdal.so /usr/lib/libgdal.so
ln -s /usr/local/lib/libgdal.so.27 /usr/lib/libgdal.so.27
cd ..

# postgis
apt-get install libxml2-dev libprotobuf-dev libprotobuf-c-dev protobuf-c-compiler
#wget https://download.osgeo.org/postgis/source/postgis-3.1.1.tar.gz
#tar -xvf postgis-3.1.1.tar.gz
cd postgis-3.1.1
./configure
make
make install
cd ..

#go
#wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz
#tar -xvf go1.15.2.linux-amd64.tar.gz
cp -r go /usr/local

#Leveldb
wget https://github.com/google/leveldb/archive/v1.23.tar.gz
tar -xvf v1.23.tar.gz
cd leveldb-1.23/
make
scp out-static/lib* out-shared/lib* /usr/local/lib/
cd include/
scp -r leveldb /usr/local/include/
cd ..

#Imposm
rm -Rf imposm3
mkdir -p imposm3
cd imposm3
export GOPATH=`pwd`
../go/bin/go get github.com/omniscale/imposm3
../go/bin/go install github.com/omniscale/imposm3/cmd/imposm@latest
cd ..

#Install libosmium (needed by osmborder)
apt-get install libbz2-dev libprotozero-dev libboost-tools-dev libboost-thread-dev cmake clang-tidy 
#git clone https://github.com/osmcode/libosmium.git
cd libosmium
mkdir build
cd build
cmake ..
make
make install
cd ..
cd ..

#Install osmborder
#git clone https://github.com/pnorman/osmborder.git
cd osmborder
mkdir build
cd build
cmake ..
make
make install