ISO = alpine-standard-3.20.1-x86_64.iso

qemu: qemu-vm1

full: vm0 sleep vm1 qemu

unpack:
	mcopy -i drive.img@@1M ::alpine.apkovl.tar.gz apkovl/
	cd apkovl; tar xf alpine.apkovl.tar.gz
	rm apkovl/alpine.apkovl.tar.gz

flash:
	sudo ./flash.sh

sleep:
	sleep 3

vm1:
	expect stage1

qemu-vm1: iso drive.img
	qemu-system-x86_64 \
		-enable-kvm -nographic \
		-m 2G \
		-drive format=raw,file=drive.img \
		-boot c

vm0:
	expect stage0

qemu-vm0: iso drive.img
	qemu-system-x86_64 \
		-enable-kvm -nographic \
		-m 2G \
		-cdrom iso/$(ISO) \
		-drive format=raw,file=drive.img \
		-boot d


iso: iso/$(ISO)
iso/$(ISO):
	wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/$(ISO)
	cd iso; sha256sum -c $(ISO).sha256

drive.img:
	fallocate -l 512M drive.img
	echo -e "o\n" | fdisk drive.img
	echo -e "n\np\n1\n\n\nw" | fdisk drive.img
	echo -e "a\nw\n" | fdisk drive.img

clean:
	rm -f drive.img
