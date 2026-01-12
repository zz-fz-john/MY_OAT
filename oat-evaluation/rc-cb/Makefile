# I guess that requiring people to instal Scons is silly, so I'll add this
# Makefile.

OPT = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/opt
VM = your-server-for-llvm:~/work/ra-project/evaluation/rc-cb/
TARGET = --target=aarch64
NOVA_PATH = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/lib/
LLC_ARM = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/llc
RPI3_GCC_CONFIG = -I/usr/arm-linux-gnueabihf/include -mfloat-abi=hard -g0 -gdwarf-2
UNAME := $(shell uname -m)
WARNING_FLAGS := -Wall -Wextra -Wshadow -Wswitch-enum \
    -Wswitch-default
C_WARNING_FLAGS := -Wmissing-prototypes -Wmissing-declarations \
    -Wstrict-prototypes
SYSROOT=/home/zrz0517/study/chain_attestation/toolchains/aarch64/aarch64-linux-gnu/libc
ifeq ($(UNAME), armv6l)
	CFLAGS := ${WARNING_FLAGS} ${C_WARNING_FLAGS} -DRASPI=1
else ifeq ($(UNAME), armv7l)
	CFLAGS := ${WARNING_FLAGS} ${C_WARNING_FLAGS} -DRASPI=2
else
	CFLAGS := ${WARNING_FLAGS} ${C_WARNING_FLAGS}
endif

LDLIBS := -lm -ljansson

#pi_pcm: pi_pcm.o mailbox.o
dtoa_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT) $(CFLAGS) -S -emit-llvm  ./jansson/dtoa.c  -o build/dtoa.bc
dump_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT) $(CFLAGS) -S -emit-llvm  ./jansson/dump.c  -o build/dump.bc
error_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT)  $(CFLAGS) -S -emit-llvm  ./jansson/error.c  -o build/error.bc
hashtable_seed_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT) $(CFLAGS) -S -emit-llvm  ./jansson/hashtable_seed.c  -o build/hashtable_seed.bc
hashtable_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT) $(CFLAGS) -S -emit-llvm  ./jansson/hashtable.c  -o build/hashtable.bc
load_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT) $(CFLAGS) -S -emit-llvm  ./jansson/load.c  -o build/load.bc
memory_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT)  $(CFLAGS) -S -emit-llvm  ./jansson/memory.c  -o build/memory.bc
pack_unpack_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT) $(CFLAGS) -S -emit-llvm  ./jansson/pack_unpack.c  -o build/pack_unpack.bc
strbuffer_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT)  $(CFLAGS) -S -emit-llvm  ./jansson/strbuffer.c  -o build/strbuffer.bc
strconv_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT)  $(CFLAGS) -S -emit-llvm  ./jansson/strconv.c  -o build/strconv.bc
utf_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT)  $(CFLAGS) -S -emit-llvm  ./jansson/utf.c  -o build/utf.bc
value_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG)  --sysroot=$(SYSROOT)  $(CFLAGS) -S -emit-llvm  ./jansson/value.c  -o build/value.bc
version_bc:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) $(RPI3_GCC_CONFIG) --sysroot=$(SYSROOT)   $(CFLAGS) -S -emit-llvm  ./jansson/version.c  -o build/version.bc
jansson_bc: dtoa_bc dump_bc error_bc hashtable_seed_bc hashtable_bc load_bc memory_bc pack_unpack_bc strbuffer_bc strconv_bc utf_bc value_bc version_bc
	/home/zrz0517/llvm-4.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/llvm-link  build/dtoa.bc build/dump.bc build/error.bc build/hashtable_seed.bc build/hashtable.bc build/load.bc build/memory.bc build/pack_unpack.bc build/strbuffer.bc build/strconv.bc build/utf.bc build/value.bc build/version.bc -o build/jansson.bc
pi_pcm: 
	clang $(CFLAGS) $(LDLIBS) pi_pcm.c -o server

pi-pcm-bc:
	#clang -D_GNU_SOURCE --target=aarch64 -S -emit-llvm pi_pcm.c -o pi_pcm.bc
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang $(TARGET) --sysroot=$(SYSROOT) -I/home/zrz0517/study/chain_attestation/OAT-Project/oat-evaluation/rc-cb/jansson -S -emit-llvm  pi_pcm.c -o pi_pcm.bc

test-combo: pi-pcm-bc jansson_bc
	/home/zrz0517/llvm-4.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/llvm-link pi_pcm.bc build/jansson.bc -o test_combo.bc


opt-combo:
	$(OPT) -load $(NOVA_PATH)/LLVMNova.so -nova < test_combo.bc > combo.bc 2>err.log
	$(OPT) -load $(NOVA_PATH)/LLVMCollectCFVHints.so -collect-ibranch-hints-pass -collect-icall-hints-pass -collect-cond-branch-hints-pass < combo.bc > combo_hints.bc 2>>err.log
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv combo_hints.bc -o combo.s

send-combo-bc:
	scp -i vm test_combo.bc $(VM)

fetch-combo-s:
	scp $(VM)/combo.s . 

bin: test-combo
	#clang combo.s -L../../data/runtime -lm -ljansson -lrt  -lsoftboundcets_rt  -lnova -lteec -lc 
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang \
  		--target=aarch64-linux-gnu \
  		-L/usr/aarch64-linux-gnu/lib \
 		combo.s \
 		../../oat-trampoline-lib/nova.o ../../oat-trampoline-lib/trampoline.o ../../oat-trampoline-lib/cfv_bellman.o  -lteec -L/home/zrz0517/OPTEE/optee_client/out/export/lib \
  		-lm -lrt  -lteec -lpthread -lc -lresolv \
  		-o rc-cb_OAT -v
scp-rc-cb:
	scp  -P 4646 rc-cb_OAT  zrz0517@10.204.121.36:/home/zrz0517/study/chain_attestation/OAT-evaluation
run-client: 
	./interactive_control.py example.json 
	
run-server: pi_pcm
	./server

sync:
	cp pi_pcm.c Makefile interactive_control.py ~/tee_workspace/ra-project/evaluation/rc-cb/ 

.PHONY:	clean
clean:
	rm -f *.o
	rm -f *.pyc
	rm -f pi_pcm

