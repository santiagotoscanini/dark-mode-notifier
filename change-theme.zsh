export PATH="/opt/homebrew/bin:$PATH"
HOME="/Users/stoscanini"

function _change_alacritty_theme() {
    sed -i '' "s/^colors:\ \*.*$/colors:\ \*$1/" "$(realpath "$HOME/.config/alacritty/color.yml")"
}

function _autoSwitchAlacrittyTheme() {
    # TODO: only run if alacritty is running
    # is_alacritty_running=$(ps aux | grep -v grep | grep Alacritty.app)
    if [[ "$DARKMODE" == '1' ]]; then
        _change_alacritty_theme tokyonight_night
    else
        _change_alacritty_theme material_lighter
    fi
}

function _autoSwitchVimTheme() {
    # Send a SIGUSR1 to every vim process, we have an autocmd listening on the other side
    for pid in $(pgrep vim); do
        kill -SIGUSR1 "$pid"
    done
}

function _autoSwitchDesktopLights() {
    # Only turn on/off lights when any of my desktop monitors is connected
    if system_profiler SPDisplaysDataType -json| jq '.SPDisplaysDataType[0].spdisplays_ndrvs[]._name' | grep -E "Mi Monitor|DELL P2419H"; then
        pushd -q "$HOME/dev/personal/dotfiles/smart-home-automations" || exit
            if [[ "$DARKMODE" == '1' ]]; then
                poetry run python3 main.py on
            else
                poetry run python3 main.py off
            fi
        popd -q || exit
    fi
}

# TODO(santiagotoscanini): add more tmux themes
#function _autoSwitchTmuxTheme() {
#}

function autoSwitchEverything() {
    _autoSwitchAlacrittyTheme
    _autoSwitchVimTheme
    _autoSwitchDesktopLights
}

autoSwitchEverything
