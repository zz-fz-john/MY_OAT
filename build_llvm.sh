#use gcc-4.9
#使用交叉编译器，若没有，请执行
sudo apt-get install g++-arm-linux-gnueabihf
sudo apt-get install gcc-arm-linux-gnueabihf
sudo apt-get install gcc-aarch64-linux-gnu
sudo apt-get install g++-aarch64-linux-gnu
cd oat-llvm40
mkdir build
cd build
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLLVM_ENABLE_ASSERTIONS=On -DLLVM_INCLUDE_TESTS=OFF -DLLVM_DEFAULT_TARGET_TRIPLE=aarch64-none-elf -DLLVM_TARGET_ARCH=AArch64 -DLLVM_TARGETS_TO_BUILD=AArch64 -DLLVM_BINUTILS_INCDIR=/home/zrz0517/gold/binutils/include  ..

make -j6
