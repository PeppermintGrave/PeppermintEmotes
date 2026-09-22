PeppermintEmotes - final package layout

PeppermintEmotes.lua
Dependencies/
  Notify.lua
  Settings.lua
  OpenEmote.lua
Data/
  EmoteSniper.json
  AnimationSniper.json
  AnimationSniperoffsale.json

The main loader has been retargeted to:
https://raw.githubusercontent.com/PeppermintGrave/PeppermintEmotes/main/

Persistent files are stored under the PeppermintEmotes/ folder instead of the old account-name folder.

Note: the three dataset files are included as repository placeholders because the web runtime could read the old raw files but could not transfer their complete contents into the local file workspace. The main script is configured to fetch the PeppermintGrave copies once those JSON files are populated in the repository.
