#/bin/sh

#
# Global
#

# 拡張子を常に表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true


#
# Trackpad
#

# Enable three finger tap (look up)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 2
# Enable other multi-finger gestures
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2

#
# Dock
#

# Automatically hide or show the Dock （Dock を自動的に隠す）
defaults write com.apple.dock autohide -bool true
# Magnificate the Dock （Dock の拡大機能を入にする）
defaults write com.apple.dock magnification -bool true
# 拡大時のサイズ
defaults write com.apple.dock largesize -float 90
# 表示位置
defaults write com.apple.dock orientation -string "left"
# 3本指でmission control & expose
defaults write com.apple.dock showMissionControlGestureEnabled -bool true
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.dock showDesktopGestureEnabled -bool true
defaults write com.apple.dock showLaunchpadGestureEnabled -bool true

killall Dock


#
# Status Bar
#

# バッテリーの%表示
defaults write com.apple.menuextra.battery ShowPercent -bool true
# 時計のデジタル表示
defaults write com.apple.menuextra.clock IsAnalog -bool false
# 時計の書式
defaults write com.apple.menuextra.clock 'DateFormat' -string 'EEE MMM d H:mm'

killall SystemUIServer


#
# Finder
#

# 隠しファイル・隠しフォルダを表示
defaults write com.apple.finder AppleShowAllFiles -bool true
# 「ライブラリ」を常に表示
chflags nohidden ~/Library

killall Finder


#
# Terminal
#

TERM_PROFILE='MyPro';
TERM_PATH='.mac/terminal/';
CURRENT_PROFILE="$(defaults read com.apple.terminal 'Default Window Settings')";
if [ "${CURRENT_PROFILE}" != "${TERM_PROFILE}" ]; then
    open "$TERM_PATH$TERM_PROFILE.terminal"
    defaults write com.apple.Terminal "Default Window Settings" -string "$TERM_PROFILE"
    defaults write com.apple.Terminal "Startup Window Settings" -string "$TERM_PROFILE"
fi
defaults import com.apple.Terminal "$HOME/Library/Preferences/com.apple.Terminal.plist"

