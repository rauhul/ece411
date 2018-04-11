#!/bin/sh
# This script can be launch using the command-line "wget https://raw.githubusercontent.com/sdenel/How-to-install-SimpleScalar-on-Ubuntu/master/Install-SimpleScalar.sh && chmod +x Install-SimpleScalar.sh && ./Install-SimpleScalar.sh"

# This is the only line requiring root permission
sudo apt-get install bison flex gzip gcc-multilib lib32z1 lib32ncurses5 lib32bz2-1.0  make gcc

# Will install SimpleScalar in ~/SimpleScalar
export IDIR=$PWD"/SimpleScalar"

mkdir $IDIR
cd $IDIR

# A simple wget commandline would not comply with licences, so SimpleScalar has to be downloaded manually
wget http://web.engr.oregonstate.edu/~guyo/simplesim-3v0e.tgz
wget http://www.simplescalar.com/downloads/simpletools-2v0.tgz
wget http://www.simplescalar.com/downloads/simpleutils-2v0.tgz

gunzip  *.tgz
tar -xf simpletools-*.tar
tar -xf simpleutils-*.tar
tar -xf simplesim-*.tar
rm *.tar
rm *.tgz

### binutils Compilation ###
cd binutils-*
./configure --host=i386-pc-linux --target=sslittle-na-sstrix --with-gnu-as --with-gnu-ld --prefix=$IDIR

# Avoiding:
# vasprintf.c:48:3: error: invalid initializer

sed -i -e "s/va_list ap = args;/va_list ap; va_copy(ap, args);/g" libiberty/vasprintf.c
# Avoiding:
# vasprintf.c:35:7: error: conflicting types for ‘malloc’
sed -i -e "s/char \*malloc ();/\/\/char \*malloc ();/g" libiberty/vasprintf.c

# Avoiding:
# ./ldlex.l:477:7: error: 'yy_current_buffer' undeclared (first use in this function)
sed -i -e "s/yy_current_buffer/YY_CURRENT_BUFFER/g" ld/ldlex.l

# Avoiding errors like: /usr/lib/gcc/x86_64-linux-gnu/4.6/include/varargs.h:4:2: error: #error "GCC no longer implements <varargs.h>."
# but also: ldmisc.c:318:31: error: expected expression before ‘char’
sed -i -e "s/varargs.h/stdarg.h/g" ld/ldmisc.c

# Avoiding errors due to an outdated code
# Inspired from http://zealoct.wordpress.com/2011/04/19/install-simplescalar-on-ubuntu-10-10-with-gcc-4-4/
# avoiding: ldmisc.c:348:15: error: macro "va_start" requires 2 arguments, but only 1 given
sed -i -e "s/  va_list arg;/\/\/  va_list arg;/g" ld/ldmisc.c
sed -i -e "s/  va_start/\/\/  va_start/g" ld/ldmisc.c
sed -i -e "s/  file/\/\/  file/g" ld/ldmisc.c
sed -i -e "s/  fmt/\/\/  fmt/g" ld/ldmisc.c
sed -i -e "s/  vfinfo/\/\/  vfinfo/g" ld/ldmisc.c
sed -i -e "s/  va_end/\/\/  va_end/g" ld/ldmisc.c

# Avoiding:
# ldmisc.c:402:6: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘va_dcl’
# ldmisc.c:344:6: error: expected declaration specifiers before ‘va_dcl’
sed -i -e "s/(va_alist)/()/g" ld/ldmisc.c
sed -i -e "s/     va_dcl/\/\/     va_dcl/g" ld/ldmisc.c
sed -i -e "s/     FILE \*fp;/\/\/     FILE \*fp;/g" ld/ldmisc.c
sed -i -e "s/     char \*fmt;/\/\/     char \*fmt;/g" ld/ldmisc.c
sed -i -e "s/vfinfo(fp, fmt, arg)/vfinfo(FILE \*fp, char \*fmt, va_list arg)/g" ld/ldmisc.c

# Avoiding:
# follows non-static declaration:
#strerror.c:467:12: error: static declaration of ‘sys_nerr’ follows non-static declaration
# static int sys_nerr;
#            ^
#In file included from /usr/include/stdio.h:853:0,
#                 from strerror.c:35:
#/usr/include/x86_64-linux-gnu/bits/sys_errlist.h:26:12: note: previous declaration of ‘sys_nerr’ was here
# extern int sys_nerr;
sed -i -e "s/NEED_sys_errlist/NEED_sys_errPROTECTEDlist/g" libiberty/strerror.c
sed -i -e "s/sys_nerr/sys_nerr_2/g" libiberty/strerror.c
sed -i -e "s/sys_errlist/sys_errlist_2/g" libiberty/strerror.c
sed -i -e "s/NEED_sys_errPROTECTEDlist/NEED_sys_errlist/g" libiberty/strerror.c

make all
make install


cd ../simplesim*
make config-alpha
make
# You can check that SimpleScalar (not the toolchain) works with the command-line:
# ./sim-safe tests-alpha/bin/test-math


cd ../
cd gcc-*

./configure --host=i386-pc-linux --target=sslittle-na-sstrix --with-gnu-as --with-gnu-ld --prefix=$IDIR

# Avoiding:
# insn-output.c:676:5: error: stray ‘\’ in program
sed -i 's/return \\"FIXME\\\\n/return \\"FIXME\\\\n\\\\/g' config/ss/ss.md
#sed -i 's/return \"FIXME\\n/return \"FIXME\\n\\/g' insn-output.c

# Do not include LIBGCC2_INCLUDES leads to
# ./libgcc2.c:1384: stdio.h: No such file or directory
# make: *** [libgcc2.a] Error 1
# make has to be launched before to correct errors...

make LANGUAGES="c c++" CFLAGS="-O3" CC="gcc"

# Avoiding:
# decl.c:3605:3: error: lvalue required as increment operand
sed -i -e "s/\*((void \*\*)__o->next_free)++ = ((void \*)datum);/\*((void \*\*)__o->next_free++) = ((void \*)datum);/g" obstack.h

# Avoiding:
# cxxmain.c:2978: error: conflicting types for ‘malloc’ - uniquement pour gcc 2.7

#chmod 755 cxxmain.c
#sed -i -e "s/char \* malloc ();/\/\/char \* malloc ();/g" cxxmain.c
#sed -i -e "s/char \* realloc ();/\/\/char \* realloc ();/g" cxxmain.c

# Avoiding:
# sdbout.c:57:18: fatal error: syms.h: No such file or directory
sed -i -e "s/#include <syms.h>/#include \"gsyms.h\"/g" sdbout.c

# Avoiding:
# cccp.c:194:14: error: conflicting types for ‘sys_errlist’
sed -i -e "s/extern char \*sys_errlist\[\];/\/\/extern char \*sys_errlist\[\];/g" cccp.c
# Avoiding:
# ./cp/g++.c:90:14: error: conflicting types for ‘sys_errlist’
sed -i -e "s/extern char \*sys_errlist\[\];/\/\/extern char \*sys_errlist\[\];/g" cp/g++.c
# Avoiding: 
# gcc.c:172:14: erreur: conflicting types for ‘sys_errlist’
sed -i -e "s/extern char \*sys_errlist\[\];/\/\/extern char \*sys_errlist\[\];/g" gcc.c

make LANGUAGES="c c++" CFLAGS="-O3" CC="gcc"
# If you do not uncompress simpletools at the right place, You will face:
# /usr/include/_G_config.h:53: unknown machine mode `_G_int16_t'
# /usr/include/_G_config.h:54: unknown machine mode `_G_int32_t'
# /usr/include/_G_config.h:55: unknown machine mode `_G_uint16_t'
# /usr/include/_G_config.h:56: unknown machine mode `_G_uint32_t'
make install LANGUAGES="c c++" CFLAGS="-O3" CC="gcc"

echo 'PATH='$IDIR'/bin:$PATH' >> ~/.bashrc
cd ../simplesim-*
echo 'PATH='$PWD':$PATH' >> ~/.bashrc

echo "This is it! Please restart your session in order to update your global variables."
