HOME="/Users/stoscanini"

function _change_alacritty_theme() {
    sed -i '' "s/^colors:\ \*.*$/colors:\ \*$1/" "$(realpath "$HOME/.config/alacritty/color.yml")"
}

function _autoSwitchAlacrittyTheme() {
    if [[ "$DARKMODE" == '1' ]]; then
        _change_alacritty_theme tokyonight_night
    else
        _change_alacritty_theme material_lighter
    fi
}

function _autoSwitchVimTheme() {
    for pid in $(pgrep vim); do
        kill -SIGUSR1 "$pid"
    done
}

function _autoSwitchDesktopLights() {
    # Only turn on/off lights when any of my desktop monitors is connected
    if system_profiler SPDisplaysDataType -json| /opt/homebrew/bin/jq '.SPDisplaysDataType[0].spdisplays_ndrvs[]._name' | grep -E "Mi Monitor|DELL P2419H"; then
        echo $(system_profiler SPDisplaysDataType -json| jq '.SPDisplaysDataType[0].spdisplays_ndrvs[]._name' | grep -E "Mi Monitor|DELL P2419H")
        pushd -q "$HOME/dev/personal/dotfiles/smart-home-automations" || exit
            if [[ "$DARKMODE" == '1' ]]; then
                /opt/homebrew/bin/poetry run python3 main.py on
            else
                /opt/homebrew/bin/poetry run python3 main.py off
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
