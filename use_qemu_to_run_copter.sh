#使用optee的qemu版本运行部署OAT后的arducopter
#build optee_qemu version
pip2 install pycryptodome
pip2 install Wand
pip3 install pycryptodomex
#解决 error while loading shared libraries: libz.so.1: cannot open shared object file: No such file or directory
sudo apt-get install lib32z1
mkdir OPTEE_qemu
cd OPTEE_qemu
repo init -u https://github.com/OP-TEE/manifest.git -m qemu_v8.xml -b 3.10.0
#可能会出现错误
[...]
fatal: manifest 'qemu_v8.xml' not available
fatal: <linkfile> invalid "src": ../toolchains/aarch64/bin/aarch64-linux-gnu-gdb: bad component: ..
#此时可以输入以下命令
(cd .repo/repo; git checkout v1.13.9)
repo init -u https://github.com/OP-TEE/manifest.git -m qemu_v8.xml -b 3.10.0
repo sync -j4 --no-clone-bundle
#然后返回optee文件夹中
cd build
make toolchains
make all
mkdir OAT
#运行
#make -j12 run-only QEMU_VIRTFS_ENABLE=y CFG_CORE_ASLR=n QEMU_VIRTFS_HOST_DIR=$(pwd)/OAT
#首先得复制arducopter相关文件到OAT文件夹中
cd /home/zrz0517/OPTEE_qemu/build/../out/bin && /home/zrz0517/OPTEE_qemu/build/../qemu/aarch64-softmmu/qemu-system-aarch64 \
	-nographic \
	-serial tcp:localhost:54320 -serial tcp:localhost:54321 \
	-smp 2 \
	-s -S -machine virt,secure=on -cpu cortex-a57 \
	-d unimp -semihosting-config enable,target=native \
	-m 1057 \
	-bios bl1.bin \
	-initrd rootfs.cpio.gz \
	-kernel Image -no-acpi \
	-append 'console=ttyAMA0,38400 keep_bootcon root=/dev/vda2' \
	-object rng-random,filename=/dev/urandom,id=rng0 -device virtio-rng-pci,rng=rng0,max-bytes=1024,period=1000 -fsdev local,id=fsdev0,path=/home/zrz0517/OPTEE_qemu/build/OAT,security_model=none -device virtio-9p-device,fsdev=fsdev0,mount_tag=host -net user,hostfwd=tcp::10022-:22,hostfwd=tcp::5760-:5760 -net nic
mkdir shared && mount -t 9p -o trans=virtio host shared 
cd shared
./arducopter_OAT -S --model + --speedup 1 --defaults ./copter.parm  -I0
#在主机端运行，需要提前安装mavproxy, 且需要找到mavproxy.py的路径
python3 mavproxy.py --master=tcp:127.0.0.1:5760 --out 127.0.0.1:14500 --console --map