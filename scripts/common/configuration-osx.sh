#!/usr/bin/env bash
set +e
echo
echo 'Customizing OS X configuration'

# set menu clock: weekday, date, 24h time (DateFormat is ignored since macOS 13)
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -int 1
defaults write com.apple.menuextra.clock Show24Hour -bool true
killall ControlCenter

# hide the dock
defaults write com.apple.dock autohide -bool true
killall Dock

# fast key repeat rate, requires reboot to take effect
defaults write ~/Library/Preferences/.GlobalPreferences KeyRepeat -int 1
defaults write ~/Library/Preferences/.GlobalPreferences InitialKeyRepeat -int 15

# set finder to display full path in title bar
defaults write com.apple.finder '_FXShowPosixPathInTitle' -bool true

# stop Photos from opening automatically
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
#to revert use defaults -currentHost delete com.apple.ImageCapture disableHotPlug


# add chrome and iTerm to the dock (keeps existing icons)
brew install dockutil
for app in "/Applications/Google Chrome.app" "/Applications/iTerm.app"; do
  if [ -d "$app" ] && ! dockutil --find "$(basename "$app" .app)" >/dev/null 2>&1; then
    dockutil --add "$app" --no-restart
  fi
done
killall Dock

# Force Preference Refresh
killall -u $USER cfprefsd

echo
echo "Configuring iTerm"
cp files/com.googlecode.iterm2.plist ~/Library/Preferences

echo "Configuring Rectangle"
if [ -d /Applications/Rectangle.app ]; then
  cp files/com.knollsoft.Rectangle.plist ~/Library/Preferences/com.knollsoft.Rectangle.plist
  open /Applications/Rectangle.app
fi

echo "Configuring FlyCut"
[ -d /Applications/Flycut.app ] && open /Applications/Flycut.app
