#!/bin/sh

if [ -f "Makefile" ]; then
	make distclean
fi



if [ -f "configure" ]; then
	rm -rf  configure
fi
./buildconf
if [ ! -f "configure" ]; then
	echo ""
	echo " --------- Run autogen Error! --------- "
	echo ""
	exit 2
fi
rm config.cache config.status -f
if [ $1 = "x86" ]
  then   
  echo "Build X86"
      ./configure   --target=i686-pc-linux-gnu \
        --host=i686-pc-linux-gnu \
        --build=i686-pc-linux-gnu \
	-disable-shared --enable-static \
	--without-ssl  --without-librtmp   \
	--disable-ldap  --disable-rtsp  --disable-dict --disable-smtp --disable-gopher --disable-manual \
	--disable-ipv6 --disable-openssl-auto-load-config --disable-sspi  --disable-crypto-auth  --without-zlib 
  elif [ $1 = "arm" ]
  then
  echo "build arm"
 PATH="/work/toolchain_R2_EABI/usr/bin:/work/toolchain_R2_EABI/usr/sbin/:$PATH" \
AR="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-ar" \
AS="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-as" \
LD="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-ld" \
NM="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-nm" \
CC="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-gcc" \
GCC="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-gcc" \
CPP="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-cpp" \
CXX="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-g++" \
FC="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-gfortran" \
RANLIB="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-ranlib" \
STRIP="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-strip" \
OBJCOPY="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-objcopy" \
OBJDUMP="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-objdump" \
AR_FOR_BUILD="/usr/bin/ar" AS_FOR_BUILD="/usr/bin/as" CC_FOR_BUILD="/usr/bin/gcc" \
GCC_FOR_BUILD="/usr/bin/gcc" CXX_FOR_BUILD="/usr/bin/g++" FC_FOR_BUILD="/usr/bin/ld" \
LD_FOR_BUILD="/usr/bin/ld" CFLAGS_FOR_BUILD="  -I/work/toolchain_R2_EABI/include -I/work/toolchain_R2_EABI/usr/include" \
CXXFLAGS_FOR_BUILD="-I/work/toolchain_R2_EABI/include -I/work/toolchain_R2_EABI/usr/include" \
LDFLAGS_FOR_BUILD="-L/work/toolchain_R2_EABI/lib -L/work/toolchain_R2_EABI/usr/lib -Wl,-rpath,/work/toolchain_R2_EABI/usr/lib" \
FCFLAGS_FOR_BUILD="" DEFAULT_ASSEMBLER="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-as" \
DEFAULT_LINKER="/work/toolchain_R2_EABI/usr/bin/arm-none-linux-gnueabi-ld" \
CFLAGS=" -pipe  -g    -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  " \
CXXFLAGS=" -pipe  -g   -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64" LDFLAGS="" FCFLAGS="" \
PKG_CONFIG="/work/toolchain_R2_EABI/usr/bin/pkg-config" \
PERLLIB="/work/toolchain_R2_EABI/usr/lib/perl" \
STAGING_DIR="/work/toolchain_R2_EABI/usr/arm-unknown-linux-gnueabi/sysroot" \
ac_cv_lbl_unaligned_fail=yes ac_cv_func_mmap_fixed_mapped=yes ac_cv_func_memcmp_working=yes \
ac_cv_have_decl_malloc=yes gl_cv_func_malloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes \
ac_cv_func_calloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes lt_cv_sys_lib_search_path_spec="" ac_cv_c_bigendian=no  \
./configure --target=arm-unknown-linux-gnueabi \
	--host=arm-unknown-linux-gnueabi \
	--build=i686-pc-linux-gnu \
	-disable-shared --enable-static \
	--prefix=/work/toolchain_R2_EABI/usr/arm-unknown-linux-gnueabi/sysroot/usr  \
         --without-ssl  --without-librtmp   \
	 --disable-ldap  --disable-rtsp  --disable-dict --disable-smtp  --disable-manual \
          --disable-gopher   --disable-ipv6 --disable-openssl-auto-load-config --disable-sspi  --disable-crypto-auth  --without-zlib 
  else
  echo "Please make sure the positon variable is start or stop."
fi

make clean 
make 
