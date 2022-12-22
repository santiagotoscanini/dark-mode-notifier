## MacOS

Heavily inspired by [dark-mode-notify](https://github.com/bouk/dark-mode-notify)

### Instalation

To install the program run:

```shell
sudo make install
```

We can test it with:

```shell
/usr/local/bin/dark-mode-notifier zsh -c 'echo test'
```

### Keep it running

To make it to run automatically, copy the file `dark-mode-notifier.plist` to `~/Library/LaunchAgents`.
```
cp $DOTFILES_PATH/alacritty/macOS/dark-mode-notifier.plist ~/Library/LaunchAgents/dark-mode-notifier.plist
```

Then `launchctl load -w ~/Library/LaunchAgents/dark-mode-notifier.plist` will keep it running on boot.
