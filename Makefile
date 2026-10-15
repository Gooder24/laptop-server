# laptop-server: `make deb && sudo apt install ./laptop-server_*.deb`
VERSION ?= 0.1.0
BUILD ?= build
OUT ?= .

.PHONY: help check install deb clean
help:
	@grep -E '^[a-z]+:.*##' $(MAKEFILE_LIST) | sed 's/:.*## /\t/' | expand -t 10

check: ## syntax and the self-test (seconds)
	bash -n laptop-server
	for f in packaging/postinst packaging/prerm packaging/postrm; do sh -n $$f || exit 1; done
	./laptop-server --self-test
	@unreadable=$$(find root ! -type l ! -perm -o=r); test -z "$$unreadable" || { echo "installed as-is, so users could not read: $$unreadable"; exit 1; }

install: ## copy the files into DESTDIR (for packaging; a running system gets them from the .deb)
	install -Dm755 laptop-server $(DESTDIR)/usr/bin/laptop-server
	cp -R root/. $(DESTDIR)/

deb: check ## build laptop-server_<version>_all.deb into OUT (default: here)
	rm -rf $(BUILD) && $(MAKE) --no-print-directory install DESTDIR=$(BUILD)/root
	install -d $(BUILD)/root/DEBIAN
	sed 's/@VERSION@/$(VERSION)/' packaging/control > $(BUILD)/root/DEBIAN/control
	install -m755 packaging/postinst packaging/prerm packaging/postrm $(BUILD)/root/DEBIAN/
	(cd $(BUILD)/root && find etc -type f -printf '/%p\n' > DEBIAN/conffiles)
	dpkg-deb --root-owner-group --build $(BUILD)/root $(OUT)/laptop-server_$(VERSION)_all.deb

clean:
	rm -rf $(BUILD) laptop-server_*.deb
