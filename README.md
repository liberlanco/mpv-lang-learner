# mpv-lang-learner

Script improvess [https://github.com/mpv-player/mpv](MPV) player with
features for language learners.

Common steps to start using it:

- Install the script and make sure it works. See `Installation` section below.
  See `Possible problems` for some troubleshooting tips.

- Configure the script. At least set the language(s) you know and the language
  you want to learn. See `Configuration` section below.

- Get movie/anime/dorama with audio track in target language and subtitles
in target language and in known language. See `Prepare video` section for this.

- Read `How to use` section to understand keybindings and
  the flow of learning process.

## Features

* Ability to quickly switch between subtitles in the language you know
  and in the language you want to learn. Even if there are dozens of subtitles
  embedded in `.mkv` file. Press `b` to jump between know/learn languages.
  Press `B` to cycle languages your know
  (if you set couple of them in the script's config)

* AB-loop for current subtitle. Very useful if you have troubles with audio recognizing.
  Press `g` to manually set AB-loop for current subtitle. Press `g` again to move forward.
  Press `F5` to enable auto-AB-loop mode. In this mode mpv will set AB-loop on every
  subtitle. Again `g` will help with moving to next subtitle.

* Seek to the start time of current subtitle. Press `c` for this. Use standard
  `Ctrl+left` and `Ctrl+right` to jump to next/previous subtitles.

* 3 configurable keys `F1`, `F2`, `F3` to open current subtitle in external
  websites. Default  settings are:
  - `F1` - https://jisho.org
  - `F2` - https://translate.google.com
  - `F3` - empty

* Ability to export current subtitle data into `to_learn` folder.
  It stores following files:
  - `.txt` - subtitle text
  - `.json` - meta info, useful to make tools to parse those files
  - `.jpg` - screenshot
  - `.mp3` - audio track between start/end of the subtitle.

  This folder can be used to create Anki flashcards later.
  (`ffmpeg` is needed to export audio).
  Default keybinding: `F6`

* Call external script with info about current subtitle.
  It will provide following data as arguments: subtitle text, path to video file,
  start timestamp, end timestamp.
  Default keybinding: `F7`

## How to use

I found 2 usefull ways how you can learn the language: when subtitles are visible, and
when subtitles are hidden.

The first way gives worse listening improvement, but it can be very helpful when target
language has complex writting system like Japanese and learner wants to practice reading too.

The second way purely concentrates on listening. Learner tries to understand from listening
as much as possible, subtitle is used to verify youself or get a clue when audio is too complex.

### Train READING (+ LISTENING a bit)

* During watching use `b` to cycle between know/learn subtitles. If there
  are couple of languages you know, then use `B` to select wanted one

* Use `c` and `Ctrl+left` / `Ctrl+right` to jump between subtitles
  (notice that `Ctrl+right` doesn't work well for future subtitles, which
   are not loaded yet, so it's more or less useful to jump between past subtitles)

* Use `F1`, `F2`, `F3` to quickly lookup current text in dictionaries or
  transators. It will also pause the video. Use default keybindings
  `f` (full screen) and `T` (on top) to deal with windows switching, it
  can be helpful.

* Use `F6` to save current subtitle in `to_learn` folder. It's for
  good phrases or frequent words you want to record in you long term
  vocabulary using cards.

* If you need more automation, prepare your script, and call it using keybinding `F7`.
  For example you can automatically create Anki card or something like that.

(tip: it also dumps current subtitile into console, for the case if you
want to copy-paste something!)

### Train LISTENING

* Important keybinding - `v` (native). It will show/hide subtitle. This means
  that you won't see subtitles, but all keybingings that uses them will
  still work, because mpv loads them and keeps internally. Hence you
  still need subtitles even for listening training.

* Right from the start of the video. Press `b` to switch to subtitle in target
  language, and then `v` to make it hidden.

* Use `c` to seek to the begining of current phrase (current subtitle), if
  you want to hear it again. Use `Ctrl+left`, `Ctrl+right` to jump between phrases.

* Use `g` to set AB-loop for current phrase (subtitle). It will repeat current phrase
  again and again. Press `g` again to move forward (or `space` to set pause rest a bit
  and get cup of coffee)

* If everything gets complex (common story at the begining), enable auto-AB-loop
  mode using `F5`. Again use `g` to move forward after you get current phrase.

* Remember that `l` is a native keybinging to set/clear AB-loop in mpv. Use it when
  subtitle start/end timestamps are not good (for example there is a long phrase,
  and you want to loop part of it)

* Use `[`, `]` (native) to change playback speed when audio is too fast.
  Press `Backspace` to reset to current speed.  `Shift+[` sets half of the speed.

* Press `v` to reveal the answer and check youself. If it didn't help, press
  `b` to cycle between know/learn languages, or press `F1`, `F2`, `F3` to
  open useful websites with current phrase.

* As in previous section use `F6` to export subtitle or `F7` to call your script
  if needed.

## Prepare video

Find movie/anime with subtitles embedded as separate ass/srt/etc tracks.
Look for `.mkv` files with a lot of subtitles in one file. If you are lucky,
you can find media with everything inside.

If you don't have video file with subtitles, than look for clean video
with audio track on target language and try to find subtitles on sites
like https://kitsunekko.net/ (for anime). MPV can automatically load
those subtitles if they are placed in the same folder and has same name
as video file itself.

(tip: it's possible to place multiple subtitle files for one video file.
Use following template to name them: `<mkv file name>.<lang>.ass`.
For example: `Some anime - 02.jpn.ass`, `Some anime - 02.eng.ass`, ...)

Usually timestamps are wrong for 3rd party subtitles. Use GUI tools to
fix timestamps. Possible tools:
- [Aegisub](https://github.com/Aegisub/Aegisub),
- [subtitlecomposer](https://github.com/maxrd2/SubtitleComposer)
- magic syncers like [ffsubsync](https://github.com/smacke/ffsubsync).
Don't forget to share your synced subs with others!

## Installation

Follow MPV instructions to install additional scripts.

On Linux:
- place `lang-learner.lua` into `~/.config/mpv/scripts/`
- place `lang-learner.conf` into `~/.config/mpv/script-opts/`

On Windows
- place `lang-learner.lua` into `C:\users\USERNAME\AppData\Roaming\mpv\scripts\`
- place `lang-learner.conf` into `C:\users\USERNAME\AppData\Roaming\mpv\script-opts\`

## Configuration

Look at `lang-learner.conf` as example and description of options.
You have to set at least `learn` and `know` variables to languages
you want to learn and already know.

## Possible problems

* **keybindings doesn't work**. It means script is not loaded.

  First possible might be in your GUI tools, that uses MPV
  internally and they don't load any scripts. To check this, try
  to start raw `mpv` from the shell.

  Another possible cause is that script crashes during load. Try
  to load `mpv` in shell in look for any error messages.

  And next possible cause is that script is in wrong path. To
  check this add `print("LOADED")` at the begining of the script
  and load it in shell. If you don't see errors and message "LOADED"
  then something wrong with paths.

* **script suddenly stops working.** It means script crashes. In
  this case MPV will disable script and all it's keybingings.
  Run `mpv` in terminal, try to reproduce, look for possible stack
  traces. Fill issue or make PR

* **configuration option doesn't work.** It means that config file
  is not loaded or has problems.

  To check that config file is loaded and it's in correct path, add
  intentionally wrong option in the config file (`abc=123`) and start mpv.
  It should print warning about unknown option.

  The check possible syntax problems again check `mpv` console output.
