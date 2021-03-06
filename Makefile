JOBS := $(shell nproc)

.PHONY: disk

libc:
	ninja -C LibC/build install -j $(JOBS)
	
liblemon:
	ninja -C LibLemon/build install -j $(JOBS)
	
applications: liblemon
	ninja -C Applications/build install -j $(JOBS)

system: liblemon
	ninja -C System/build install -j $(JOBS)

kernel:
	ninja -C Kernel/build
	
userspace: liblemon applications
	
initrd: libc liblemon
	Scripts/buildinitrd.sh
	
base: applications system
	Scripts/buildbase.sh

disk: kernel base initrd
	Scripts/build-nix/copytodisk.sh
	
clean:
	ninja -C LibC/build clean
	ninja -C LibLemon/build clean
	ninja -C Applications/build clean
	ninja -C Kernel/build clean
	find Base/ -type f -not -name '*.cfg' -delete
	rm -rf Initrd/*
	rm initrd.tar
	
cleanall:
	rm -rf LibC/build LibLemon/build Applications/build Kernel/build
	find Base/ -type f -not -name '*.cfg' -delete
	rm -rf Initrd/*
	rm initrd.tar
	
run:
	Scripts/run.sh

qemu: run

vbox:
	Scripts/run.sh vbox
	
debug:
	Scripts/run.sh debug_qemu
