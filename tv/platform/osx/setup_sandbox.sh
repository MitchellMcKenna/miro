#/bin/bash

# =============================================================================

SANDBOX_VERSION=2

# =============================================================================

ROOT_DIR=$(cd ../../../../;pwd)
while getopts ":r:v" option
    do
    case $option in
    r)
        ROOT_DIR=$OPTARG
        ;;
    v)
        echo $SANDBOX_VERSION
        exit
        ;;
    esac
done

SANDBOX_DIR=$ROOT_DIR/sandbox
PKG_DIR=$SANDBOX_DIR/pkg
OUT=$SANDBOX_DIR/setup.log

# =============================================================================

echo "Setting up sandbox in $ROOT_DIR"
mkdir -p $PKG_DIR

# =============================================================================
# Pyrex 0.9.6.2 (0.9.6.3 setup script is currently broken!!)
# =============================================================================

echo "Setting up Pyrex 0.9.6.2"

echo ">> Downloading archive..."
cd $PKG_DIR
curl --location --silent --remote-name "http://www.cosc.canterbury.ac.nz/greg.ewing/python/Pyrex/oldtar/Pyrex-0.9.6.2.tar.gz"

echo ">> Unpacking archive..."
tar -xzf Pyrex-0.9.6.2.tar.gz
cd $PKG_DIR/Pyrex-0.9.6.2

echo ">> Installing..."
python setup.py install --prefix=$SANDBOX_DIR &> $OUT

# =============================================================================
# Boost 1.33.1
# (because boost 1.34.x causes the libtorrent python extension to fail)
# =============================================================================

echo "Setting up Boost 1.33.1"

echo ">> Downloading archive..."
cd $PKG_DIR
curl --location --silent --remote-name "http://downloads.sourceforge.net/boost/boost_1_33_1.tar.gz"

echo ">> Unpacking archive..."
tar -xzf boost_1_33_1.tar.gz
cd $PKG_DIR/boost_1_33_1

echo ">> Building the bjam tool..."
pushd tools/build/jam_src &> $OUT
./build.sh &> $OUT
popd &> $OUT

echo ">> Building & installing..."
PYTHON_ROOT=`python -c "import sys; print sys.prefix" 2>&1`

./tools/build/jam_src/bin.macosxppc/bjam --prefix=$SANDBOX_DIR \
                                         --with-python \
                                         --with-date_time \
                                         --with-filesystem \
                                         --with-thread \
                                         --without-icu \
                                         -sCFLAGS="-foo" \
                                         -sPYTHON_ROOT=$PYTHON_ROOT \
                                         -sBUILD="release" \
                                         -sTOOLS="darwin" \
                                         install &> $OUT

echo ">> Removing static libraries..."
rm $SANDBOX_DIR/lib/libboost*.a

echo ">> Updating dynamic libraries identification names.."
for lib in $SANDBOX_DIR/lib/libboost*.dylib
    do
    install_name_tool -id $lib $lib
done

# =============================================================================

echo $SANDBOX_VERSION > $SANDBOX_DIR/version.log

# =============================================================================
