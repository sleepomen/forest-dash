# Forest Dash 🦊

A small 2D platformer made in [Godot 4](https://godotengine.org) for
**Hack Club Jumpstart**.

A little fox got lost on the way home. Run and jump through the forest,
collect berries, squash slimes, dodge thorns, and make it back to the den.

▶️ **Play it here:** _(add your itch.io link once the page is public)_

## Controls

| Action  | Keys                    |
| ------- | ----------------------- |
| Move    | `A` / `D` or `←` / `→`  |
| Jump    | `Space`, `W` or `↑`     |
| Restart | `R`                     |

## Features

- Snappy platformer movement with coyote time, a jump buffer and
  variable jump height, so the controls feel forgiving.
- Berries to collect (10 points each) and slimes you can stomp (25 points).
- Thorn bushes, bottomless gaps, 3 hearts and a checkpoint-style respawn.
- Parallax forest background, sound effects and background music.
- All art and audio were generated for this project, so nothing is
  borrowed from an asset pack.

## Project layout

```
assets/art/      sprites, tiles and background layers (PNG)
assets/audio/    sound effects and music (WAV)
assets/*.tres    SpriteFrames animation resources
scenes/          main.tscn (the level) plus one scene per game object
scripts/         one GDScript per game object
```

`scenes/main.tscn` is the level. `scripts/game.gd` is an autoload that
holds the score, the lives and the sound player, so any script can just
call `Game.collect_berry()`.

## Running it

1. Open Godot 4 and click **Import**, then pick this folder's
   `project.godot`.
2. Press `F5` (or the play button) to play.

## Exporting for the web

A **Web** export preset is already set up. In Godot go to
**Project → Export**, select **Web**, use **Manage Export Templates →
Download and Install** the first time, then click **Export Project**.
Zip up everything that lands in the export folder and upload the zip to
itch.io as an HTML project.

---

Made with 🧡 for [Hack Club](https://hackclub.com) Jumpstart.
