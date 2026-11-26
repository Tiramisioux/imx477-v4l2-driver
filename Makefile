obj-m += imx477.o
obj-m += cef168.o

KDIR ?= /lib/modules/$(shell uname -r)/build

all:
	make -C $(KDIR) M=$(shell pwd) modules

clean:
	make -C $(KDIR) M=$(shell pwd) clean

%.dtbo: %.dts
	cpp -nostdinc -I . -undef -x assembler-with-cpp $< | \
		dtc -Wno-interrupts_property -Wno-unit_address_vs_reg -@ \
		-I dts -O dtb -o $@
