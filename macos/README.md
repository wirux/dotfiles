# ⌨️ macOS Keyboard Preferences

Snapshot of the two `~/Library/Preferences` domains that hold the macOS keyboard setup:

- **`com.apple.symbolichotkeys.plist`** — system keyboard shortcuts (Spotlight, Mission Control, screenshots, input-source switching, …), including the ones disabled to free up keys for Karabiner / Glove80.
- **`com.apple.HIToolbox.plist`** — input sources (Polish Pro, Press and Hold, Character Palette), the currently selected layout and the Fn-key behaviour (`AppleFnUsageType`).

These files are **not** symlinked — macOS owns them and `cfprefsd` rewrites them at will. They are exported snapshots.

## Restore on a new machine

```sh
defaults import com.apple.symbolichotkeys ~/.config/macos/com.apple.symbolichotkeys.plist
defaults import com.apple.HIToolbox ~/.config/macos/com.apple.HIToolbox.plist
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
```

Log out and back in if a shortcut still behaves the old way.

## Re-export after changing shortcuts

```sh
defaults export com.apple.symbolichotkeys ~/.config/macos/com.apple.symbolichotkeys.plist
defaults export com.apple.HIToolbox ~/.config/macos/com.apple.HIToolbox.plist
plutil -convert xml1 ~/.config/macos/*.plist
```

`defaults export` writes a binary plist; the `plutil` pass converts it back to XML so the diffs stay readable.

> **Note:** `HIToolbox` also stores volatile state (`AppleInputSourceHistory`, `AppleInputSourceUpdateTime`), so a re-export will show churn even when nothing meaningful changed.
