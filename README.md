# mpv-lang-learner

Scripts to tune MPV into the video player for language learners.

## Features

* Key to switch subtitles between language you learn and language you
  know. Very useful when there are 30 languages in `.mkv`. <br/>
  Default: `b`
* Cycle prefered languages you know if there are any. <br/>
  Default: `B`
* Key to AB loop current sutitle, and reset. <br/>
  Default: `F5`
* Auto AB loop mode that will loop each subtitle. Use key above or `l`
  (default) to move forward. <br/>
  Default: `g`
* Quick seek to begining of current subtitle (addition to standard
  `Ctrl+left` and `Ctrl+right`). <br/>
  Default: `c`
* Open subtitle in browser. 3 possible URLs. <br/>
  Default URLs: Jisho and google translate <br/>
  Default: `F1`, `F2`, `F3`.
* Store current subtitle in `to_learn` folder. It stores text (`.txt`),
  meta info (`.json`) and audio (`.mp3`). For later adding into flash
  cards and so on. (`ffmpeg` is needed for audio). <br/>
  Default: `F6`
* Call external script with current subtitle, file, start, stop
  timestamps. <br/>
  Default: `F7`


## How to use

### Train READING
* Use `b` to cycle between language you know and language you learn.
* If there are several languages you know, use `B` to cycle between them.
  After that `b` will use selected language.
* `Ctrl+left` / `Ctrl+right` (native bindings) to find needed subtitle.
  (notice it work well only for subtitles that were already shown)
* Use `F1` or `F2` to quickly lookup current text in dictionaries or
  transators. It will also pause the video.  May be default bindings
  `f` (full screen) and `T` (on top) will be useful when working with
  multiple windows.
* Use `F6` to save current subtitle in `to_learn` folder. It's for
  good phrases or frequent words you want to learn separately.
* You can prepare a script and setup it for `F7` to (for example)
  automatically create flash cards in Anki.

(tip: it also dumps current subtitile into console, for the case if you
want to copy-paste something!)

### Train LISTENING
* Important button - `v` (native binding). It will show/hide subtitle,
  but it's still there! All saving/repeating and so on for that subitile
  should work. So right from the begining, switch to lang you want to
  learn (once `b`) and press `v` to hide it.
* Use `c` to seek to the begining of current subtitle, or (for listeners)
  to repeat the phrase.
* Use `g` to AB loop current subtitle (phrase). Press `g` again to move
  forward.
* If everything gets complex, use `F5` to AB loop each phrase
  automatically. Each time you understand it, press `g` to move forward.
  If you give up, press `v` to show answer, and `b` or `F1`/`F2`/`F3` to
  show translation.
* Again use `F6` or `F7` to remember good phrases for later learning.
* Use `[`, `]` (native) to change the speed. Use `Backspace` to reset
  speed to normal. (tip: `Shift+[` will half the speed)

## Configuration

Look at `lang-learner.conf` for example and description of options.

## How to prepare movie

Find movie/anime with switchable subtitles. Look for `.mkv` files and
sources that embedds a lot of subtitles in one file. If you are lucky,
you can find media with needed subtitles right inside.

If you miss some subtitle, look at sites like https://kitsunekko.net/
(for anime). Download and rename them to match movie/episode name.

(tip: to make external subtitle to have lang id, use following template
for naming: `<mkv file name>.<lang>.ass`.
For instance: `Some anime - 02.jpn.ass`)

Usually you have to sync external subtitles. Use GUI tools to edit subs
like [Aegisub](https://github.com/Aegisub/Aegisub),
[subtitlecomposer](https://github.com/maxrd2/SubtitleComposer) or magic
syncers like [ffsubsync](https://github.com/smacke/ffsubsync). Don't
forget to share your work for others!

## Installation

Follow MPV instructions to install. (usually `.lua` should go into
`~/.config/mpv/scripts/` and `.conf` into `~/.config/mpv/scrip-opts/`).

## Possible problems

* **doesn't load** Check script path. Try to call `mpv` from shell,
  some frontends known to disable script loading. Uncomment line
  `print("LOADED")` at the begining of the script as a sign that it's
  loaded for easier debugging.
* **suddenly stops working.** Run in terminal, try to reproduce, look
  in terminal for possible stack traces. If script crashes, then MPV
  disables it and disables all bindings.
* **configuration option doesn't work.** Run in console and watch for
  warnings about unknown options. Add wrong option (`abc=123`) in
  config file, and start mpv. If there is no warning, then MPV doesn't
  load config file at all. Check paths and naming.
