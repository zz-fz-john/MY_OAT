TEST ?= test_combo
#CC = aarch64-linux-gnu-gcc
CC = gcc
NUC_PC ?= your-pc-ip 
NUC_TARGET ?= ~/work/ra-project/evaluation/alarm4pi/
objdump ?= aarch64-linux-gnu-objdump 
hikey ?= your-hikey-board-ip 
TEEC_EXPORT ?= /home/linaro/work/tee/export/
TA ?= /home/linaro/work/tee/ta/
hikey_target ?= ~/work/alarm4pi/
TARGET = --target=aarch64
NOVA_PATH = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/lib/
LLC_ARM = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/llc
RPI3_GCC_CONFIG = -I/usr/arm-linux-gnueabihf/include -mfloat-abi=hard -g0 -gdwarf-2
CFLAGS += -Wall -I$(TA)/include -I$(TEEC_EXPORT)/include -I./include
#Add/link other required libraries here
LDADD += -lteec -L$(TEEC_EXPORT)/lib -lresolv -pthread
LDADD_ORIG += -lresolv -pthread
OPT = /home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/opt
VM = your-server-for-llvm:~/work/ra-project/evaluation/alarm4pi-cb/

util:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm util.c -o util.bc

bcm-gpio:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm bcm_gpio.c -o bcm_gpio.bc

alarm4pi:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm alarm4pi.c -o alarm4pi.bc

log-msgs:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm log_msgs.c -o log_msgs.bc

proc-helper:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang   $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm proc_helper.c -o proc_helper.bc

public-ip:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm public_ip.c -o public_ip.bc

pushover:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm pushover.c -o pushover.bc

gpio-polling:
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang  $(TARGET) $(RPI3_GCC_CONFIG) -S -emit-llvm gpio_polling.c -o gpio_polling.bc

gpio-polling-orig:
	clang -S -emit-llvm gpio_polling_orig.c -o gpio_polling_orig.bc

test-orig: util alarm4pi gpio-polling-orig pushover public-ip proc-helper log-msgs bcm-gpio
	$(CC) $(LDADD_ORIG) -g util.o alarm4pi.o gpio_polling_orig.o pushover.o public_ip.o proc_helper.o log_msgs.o bcm_gpio.o  -o test_orig
	
test-combo: util alarm4pi gpio-polling pushover public-ip proc-helper log-msgs bcm-gpio 
	/home/zrz0517/llvm-4.0/clang+llvm-4.0.0-x86_64-linux-gnu-ubuntu-16.04/bin/llvm-link util.bc alarm4pi.bc gpio_polling.bc pushover.bc public_ip.bc proc_helper.bc log_msgs.bc bcm_gpio.bc -o test_combo.bc 

opt-combo:
	$(OPT) -load $(NOVA_PATH)/LLVMNova.so -nova < test_combo.bc > combo.bc 2>err.log
	$(OPT) -load $(NOVA_PATH)/LLVMCollectCFVHints.so -collect-ibranch-hints-pass -collect-icall-hints-pass -collect-cond-branch-hints-pass < combo.bc > combo_hints.bc 2>>err.log
	$(LLC_ARM) -march=aarch64  -aarch64-enable-cfv combo_hints.bc -o combo.s

send-combo-s:
	scp combo.s machine-name:~/tmp/hikey-relay/

send-combo-bc:
	scp -i vm test_combo.bc $(VM)

fetch-combo-s:
	scp $(VM)/combo.s . 

bin: test-combo
	#clang combo.s -L../../data/runtime -lm -lrt  -lsoftboundcets_rt  -lnova -lteec -lpthread  -lc -lresolv
	#/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang combo.s -L../../data/runtime -lm -lrt  -lnova -lteec -lpthread  -lc -lresolv
	/home/zrz0517/study/chain_attestation/OAT-Project/oat-llvm40/build/bin/clang \
  		--target=aarch64-linux-gnu \
  		-L/usr/aarch64-linux-gnu/lib \
 		 combo.s \
 		../../oat-trampoline-lib/nova.o ../../oat-trampoline-lib/trampoline.o ../../oat-trampoline-lib/cfv_bellman.o  -lteec -L/home/zrz0517/OPTEE/optee_client/out/export/lib \
  		-lm -lrt  -lteec -lpthread -lc -lresolv \
  		-o alarm4pi_OAT -v
dis-combo:
	llvm-dis < test_combo.bc >test_combo.dis

send-combo:
	scp -i pi $(TEST) $(NUC_PC):~/work/ra-project/evaluation/hook-a64/

send-hikey:
	scp $(TEST) $(hikey):$(hikey_target)

sync-hikey:
	scp -r *.c *.h hooks_a64.S *.ld Makefile lib/ $(hikey):$(hikey_target)

sync-nuc:
	scp -i pi -r *.c *.h hooks_a64.S *.ld Makefile lib/ $(NUC_PC):$(NUC_TARGET)
scp-alarm4pi-cb:
	scp  -P 4646 alarm4pi_OAT  zrz0517@10.204.121.36:/home/zrz0517/study/chain_attestation/OAT-evaluation
clean:
	rm *.o
	rm test

dump:
	$(objdump) $(TEST) -D > $(TEST).dump

ph:
	readelf -S  $(TEST)

sh:
	readelf -l  $(TEST)

# Compile Note: cdefs.h not found can be solved by the following cmd
#time CPATH=/usr/include/aarch64-linux-gnu/ make test-combo
