# All the actual Makefiles are deeper in the directory tree.  
# I am just calling them, here.

PREFIX=/usr
DESTDIR=

all :
	$(MAKE) -C cppForSwig

clean :
	$(MAKE) -C cppForSwig clean
	rm -f osxbuild/build-app.log.txt
	rm -rf osxbuild/workspace/
	rm -f CppBlockUtils.py
	rm -f qrc_img_resources.py
	rm -f _CppBlockUtils.so
	rm -f cppForSwig/cryptopp/a.out
	rm -f *.pyc BitTornado/*.pyc bitcoinrpc_jsonrpc/*.pyc ui/*.pyc
	rm -f armoryengine/*.pyc dialogs/*.pyc BitTornado/BT1/*.pyc
	rm -f pytest/*.pyc txjsonrpc/*.pyc jsonrpc/*.pyc txjsonrpc/web/*.pyc 

install : all
	mkdir -p $(DESTDIR)$(PREFIX)/share/viacoinarmory/img
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/extras
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/bitcoinrpc_jsonrpc
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/txjsonrpc
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/txjsonrpc/web
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/ui
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/pytest
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/BitTornado/BT1
	mkdir -p $(DESTDIR)$(PREFIX)/lib/viacoinarmory/urllib3
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp dpkgfiles/viacoinarmory $(DESTDIR)$(PREFIX)/bin
	chmod +x $(DESTDIR)$(PREFIX)/bin/viacoinarmory
	cp *.py *.so README $(DESTDIR)$(PREFIX)/lib/viacoinarmory/
	rsync -rupE armoryengine $(DESTDIR)$(PREFIX)/lib/viacoinarmory/
	rsync -rupE --exclude="img/.DS_Store" img $(DESTDIR)$(PREFIX)/share/viacoinarmory/
	cp extras/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/extras
	cp bitcoinrpc_jsonrpc/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/bitcoinrpc_jsonrpc
	cp -r txjsonrpc/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/txjsonrpc
	cp -r txjsonrpc/web/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/txjsonrpc/web
	cp ui/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/ui
	cp pytest/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/pytest
	cp -r urllib3/* $(DESTDIR)$(PREFIX)/lib/viacoinarmory/urllib3
	mkdir -p $(DESTDIR)$(PREFIX)/share/applications
	cp BitTornado/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/BitTornado
	cp BitTornado/BT1/*.py $(DESTDIR)$(PREFIX)/lib/viacoinarmory/BitTornado/BT1
	cp default_bootstrap.torrent $(DESTDIR)$(PREFIX)/lib/viacoinarmory
	#sed "s:python /usr:python $(PREFIX):g" < dpkgfiles/viacoinarmory.desktop > $(DESTDIR)$(PREFIX)/share/applications/viacoinarmory.desktop
	#sed "s:python /usr:python $(PREFIX):g" < dpkgfiles/viacoinarmoryoffline.desktop > $(DESTDIR)$(PREFIX)/share/applications/viacoinarmoryoffline.desktop
	#sed "s:python /usr:python $(PREFIX):g" < dpkgfiles/viacoinarmorytestnet.desktop > $(DESTDIR)$(PREFIX)/share/applications/viacoinarmorytestnet.desktop

all-test-tools: all
	$(MAKE) -C cppForSwig/gtest

test: all-test-tools
	(cd cppForSwig/gtest && ./CppBlockUtilsTests)
	python -m unittest discover

osx :
	chmod +x osxbuild/deploy.sh
	cd osxbuild; ./deploy.sh
