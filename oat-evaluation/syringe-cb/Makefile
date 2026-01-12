TEST ?= test_combo
CC = aarch64-linux-gnu-gcc
NUC_PC ?= your-pc-ip 
objdump ?= aarch64-linux-gnu-objdump 
hikey ?= your-hikey-board-ip 
TEEC_EXPORT ?= /your/path/to/work/tee_workspace/devel/optee_hikey_debian/optee_client/out/export
TA ?= /your/path/to/work/tee_workspace/devel/optee_hikey_debian/hello_world/ta

CFLAGS += -Wall -I$(TA)/include -I$(TEEC_EXPORT)/include -I./include
#Add/link other required libraries here
LDADD += -lteec -L$(TEEC_EXPORT)/lib
TARGET = --target=aarch64
NOVA_PATH = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/lib/
LLC_ARM = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/llc
RPI3_GCC_CONFIG = -I/usr/arm-linux-gnueabihf/include -mfloat-abi=hard -g0 -gdwarf-2

OPT = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/opt

VM = your-server-for-llvm:~/work/ra-project/evaluation/syringe-cb/

util:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm util.c -o util.bc

lcd:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm LiquidCrystal.c -o LiquidCrystal.bc

led:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm led.c -o led.bc

syringe:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm syringePump.c -o syringePump.bc

test-combo: syringe led lcd util
	/home/zrz0517/llvm-4.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/llvm-link  syringePump.bc util.bc led.bc LiquidCrystal.bc -o test_combo.bc

opt-combo:
	#$(opt) -load $(NOVA_PATH)/LLVMNova.so -nova < test_combo.bc > combo.bc 2>/dev/null
	$(OPT) -load $(NOVA_PATH)/LLVMNova.so -nova < test_combo.bc > combo.bc 2>clog.txt
	$(OPT) -load $(NOVA_PATH)/LLVMCollectCFVHints.so -collect-ibranch-hints-pass -collect-icall-hints-pass -collect-cond-branch-hints-pass < combo.bc > combo_hints.bc
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv combo_hints.bc -o combo.s

send-combo-bc:
	scp -i vm test_combo.bc $(VM)

send-combo-s:
	scp combo.s nuc:~/tmp/hikey-relay/

fetch-combo-s:
	scp $(VM)/combo.s . 

asm-combo:
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv=false test_combo.bc -o combo.s

opt-hello:
	$(opt) -load $(NOVA_PATH)/LLVMNova.so -nova < hello.bc > combo.bc 2>/dev/null
	$(opt) -load $(NOVA_PATH)/LLVMCollectCFVHints.so -collect-ibranch-hints-pass -collect-icall-hints-pass -collect-loop-hints-pass < combo.bc > combo_hints.bc
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv combo_hints.bc -o combo.s

bin:
	#clang combo.s -L../../data/runtime -lm -lrt  -lsoftboundcets_rt  -lnova -lteec
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang \
  		--target=aarch64-linux-gnu \
  		-L/usr/aarch64-linux-gnu/lib \
 		 combo.s \
 		../../oat-trampoline-lib/nova.o ../../oat-trampoline-lib/trampoline.o ../../oat-trampoline-lib/cfv_bellman.o  -lteec -L/home/zrz0517/OPTEE/optee_client/out/export/lib \
  		-lm -lrt  -lteec -lpthread -lc -lresolv \
  		-o syringe-cb_OAT -v

scp-syringe-cb:
	scp  -P 4646 syringe-cb_OAT  zrz0517@10.204.121.36:/home/zrz0517/study/chain_attestation/OAT-evaluation