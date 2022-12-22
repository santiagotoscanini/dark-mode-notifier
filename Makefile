prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/dark-mode-notifier" "$(bindir)"
	cp ./dark-mode-notifier.plist ~/Library/LaunchAgents/me.toscanini.dark-mode-notifier.plist
	launchctl load -w ~/Library/LaunchAgents/me.toscanini.dark-mode-notifier.plist

uninstall:
	rm -rf "$(bindir)/dark-mode-notify"
	rm -f  "~/Library/LaunchAgents/me.toscanini.dark-mode-notifier.plist"
	launchctl unload ~/Library/LaunchAgents/me.toscanini.dark-mode-notifier.plist

clean:
	rm -rf .build

.PHONY: build install uninstall clean
