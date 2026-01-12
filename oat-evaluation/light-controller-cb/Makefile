# I guess that requiring people to instal Scons is silly, so I'll add this
# Makefile.

OPT = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/opt
VM = your-server-for-llvm:~/work/ra-project/evaluation/light-controller-cb/

NOVA_PATH = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/lib/
LLC_ARM =  /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/llc
RPI3_GCC_CONFIG = -I/usr/arm-linux-gnueabihf/include -mfloat-abi=hard -g0 -gdwarf-2
FILE=insPi.sh

UNAME := $(shell uname -m)
WARNING_FLAGS := -Wall -Wextra -Wshadow -Wswitch-enum \
    -Wswitch-default
C_WARNING_FLAGS := -Wmissing-prototypes -Wmissing-declarations \
    -Wstrict-prototypes

ifeq ($(UNAME), armv6l)
	CFLAGS := ${WARNING_FLAGS} ${C_WARNING_FLAGS} -DRASPI=1
else ifeq ($(UNAME), armv7l)
	CFLAGS := ${WARNING_FLAGS} ${C_WARNING_FLAGS} -DRASPI=2
else
	CFLAGS := ${WARNING_FLAGS} ${C_WARNING_FLAGS}
endif

LDLIBS := -ltelldus-core -rdynamic

light-controller: 
	clang $(CFLAGS) $(LDLIBS) light-controller.c -o server

lc-bc:
	#clang -D_GNU_SOURCE --target=aarch64 -S -emit-llvm light-controller.c -o light-controller.bc
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm  light-controller.c -o light-controller.bc

test-combo: lc-bc
	/home/zrz0517/llvm-4.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/llvm-link light-controller.bc -o test_combo.bc

opt-combo:
	$(OPT) -load $(NOVA_PATH)/LLVMNova.so -nova < test_combo.bc > combo.bc 2>err.log
	$(OPT) -load $(NOVA_PATH)/LLVMCollectCFVHints.so -collect-ibranch-hints-pass -collect-icall-hints-pass -collect-cond-branch-hints-pass < combo.bc > combo_hints.bc 2>>err.log
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv combo_hints.bc -o combo.s

send-combo-bc:
	scp -i vm test_combo.bc $(VM)

fetch-combo-s:
	scp $(VM)/combo.s . 

fetch-file:
	scp $(VM)/$(FILE) . 

bin: test-combo
	#clang combo.s -L../../data/runtime -lm $(LDLIBS) -lrt  -lsoftboundcets_rt  -lnova -lteec -lc 
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang \
	--target=aarch64-linux-gnu \
	-L/usr/aarch64-linux-gnu/lib \
		combo.s \
	../../oat-trampoline-lib/nova.o ../../oat-trampoline-lib/trampoline.o ../../oat-trampoline-lib/cfv_bellman.o  -lteec -L/home/zrz0517/OPTEE/optee_client/out/export/lib \
	-lm -lrt  -lteec -lpthread -lc -lresolv \
	-o light-controller_OAT -v
scp-light-controller-cb:
	scp  -P 4646 light-controller_OAT  zrz0517@10.204.121.36:/home/zrz0517/study/chain_attestation/OAT-evaluation
run-client: 
	./interactive_control.py example.json 
	
run-server: light-controller
	./server

sync:
	cp light-controller.c Makefile interactive_control.py ~/tee_workspace/ra-project/evaluation/rc-cb/ 

.PHONY:	clean
clean:
	rm -f *.o
	rm -f *.pyc
	rm -f light-controller

