include config.mk

all:
	@echo enjoy the ride
	@cargo build --release
	@cp -r translations ./target/release/

clean: ./target
	@rm -rf -- target

install: ./target/release/hello-world
	@install -Dm755 -- ./target/release/hello-world $(DESTDIR)$(PREFIX)/bin/hello-world

uninstall: $(DESTDIR)$(PREFIX)/bin/hello-world
	@rm -- $(DESTDIR)$(PREFIX)/bin/hello-world

test: tests

tests:
	@cargo test
