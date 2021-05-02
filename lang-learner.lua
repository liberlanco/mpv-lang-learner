-- MPV for language learners setup
--
-- Provides following features:
--  1. One-key switch between subs you can read and
--     lang you are learning
--  2. Ability to seek to start or AB loop current subtitle
--  3. Auto AB loop mode - will loop each subtitle one by one
--  4. Open subtitle (3 keys for 3 possible sites)
--  5. One-key saving subtitle and audio in "to_learn" directory
--     for later adding to cards and so on
--  6. Ability to run external script, to create cards right
--     from MPV
--
--  To install follow MPV instructions to install scripts.
--  .lua file should go into scripts/ directory,
--  .conf into script-opts/
--
-- License: GNU Lesser General Public License as published
-- by the Free Software Foundation; either version 2.1 of
-- the License, or (at your option) any later version.
--

-- print("LOADED")

local utils = require("mp.utils")
local options = require("mp.options")

local o = {
  trace_subs = true,

  learn = "jpn",
  know = "jpn+eng eng",

  browser = "x-www-browser",
  url1 = "https://jisho.org/search/%s",
  url2 = "https://translate.google.com/?sl=auto&text=%s",
  url3 = "",

  store_dir = "to_learn",
  script = "",

  key_toggle_lang = "b",
  key_cycle_known = "B",
  key_seek_cur_sub = "c",
  key_ab_loop_sub = "g",
  key_open_url1 = "F1",
  key_open_url2 = "F2",
  key_open_url3 = "F3",
  key_auto_ab_loop = "F5",

  key_store = "F6",
  key_script = "F7",
}
options.read_options(o, "lang-learner")

local auto_ab_loop_sub = false
local is_learn_lang = false
local data = nil

--
-- Handlers for commands
--
function do_toggle_lang()
  load_data()

  if is_learn_lang then
    set_slang('know')
    is_learn_lang = false
  else
    set_slang('learn')
    is_learn_lang = true
  end
end

function do_cycle_known()
  load_data()
  cycle_lang_type('know')
  set_slang('know')
end

function do_seek_current_sub()
  mp.commandv('sub-seek', '0')
end

function do_ab_loop_sub()
  if mp.get_property("ab-loop-a") ~= "no" then
    clear_ab_loop()
    mp.osd_message("Clear AB loop", 0.5)
  else
    if get_sub() == nil then return; end
    set_ab_loop()
    mp.osd_message("AB-Loop subtitle", 0.5)
  end
end

function toggle_auto_ab_loop()
  if auto_ab_loop_sub then
    auto_ab_loop_sub = false
    clear_ab_loop()
    mp.osd_message('Disable auto AB loop')
  else
    auto_ab_loop_sub = true
    set_ab_loop()
    mp.osd_message('Enable auto AB loop')
  end
end

function do_open_in_url(tag)
  if o[tag] == "" then return; end

  local sub = get_sub()
  if sub == nil then return; end

  local url = string.format(o[tag], sub['text'])
  -- print("Open URL: " .. url)
  mp.set_property("pause", "yes")
  mp.commandv("run", o["browser"], url)
end

function do_store(tag)
  local sub = get_sub()
  if sub == nil then return; end
  sub['source'] = mp.get_property('filename')

  local dir = o['store_dir']
  if dir == "" or dir == nil then return; end

  mp.commandv("run", "mkdir", "-p", dir)

  local filename = string.format("%s/%s-sub", dir, os.date("!%Y%m%dT%H%M%S"))
  save_sub(filename .. '.txt', sub)
  save_json(filename .. '.json', sub)
  save_audio(filename .. '.mp3', sub)
end

function do_script(tag)
  local sub = get_sub()
  if sub == nil then return; end

  call_ext_script(sub)
end

mp.add_key_binding(o["key_toggle_lang"], "ll-toggle-lang", do_toggle_lang)
mp.add_key_binding(o["key_cycle_known"], "ll-cycle-known", do_cycle_known)

mp.add_key_binding(o["key_seek_cur_sub"], "ll-seek-cur-sub", do_seek_current_sub)

mp.add_key_binding(o["key_ab_loop_sub"], "ll-ab-loop-sub", do_ab_loop_sub)
mp.add_key_binding(o["key_auto_ab_loop"], "ll-toggle-auto-ab-loop", toggle_auto_ab_loop)

mp.add_key_binding(o["key_open_url1"], "ll-open-in-url1", function() do_open_in_url('url1'); end)
mp.add_key_binding(o["key_open_url2"], "ll-open-in-url2", function() do_open_in_url('url2'); end)
mp.add_key_binding(o["key_open_url3"], "ll-open-in-url3", function() do_open_in_url('url3'); end)

mp.add_key_binding(o["key_store"], "ll-store", do_store)
mp.add_key_binding(o["key_script"], "ll-script", do_script)

--
-- Auto AB loop for new subs
--
local cur_subs = {}
function on_new_sub(name, val)
  if val == nil then return; end
  if val == "" then
    cur_subs = {}
    return
  end

  if cur_subs[val] == true then
    return
  end
  cur_subs[val] = true

  if o["trace_subs"] then
    print("Sub: " .. utils.to_string(val))
  end

  if auto_ab_loop_sub then
    set_ab_loop()
  end
end

mp.observe_property("sub-text", "string", on_new_sub)

--
-- Helpers
--
function load_data()
  if data ~= nil then return; end

  data = {}
  data['by_lang'] = {}
  for i,track in ipairs(mp.get_property_native("track-list")) do
    if track['type'] == "sub" then
      lang = track['lang'] or string.format('id-%d', track['id'])
      data['by_lang'][lang] = track
    end
  end

  for i,tag in ipairs({'learn', 'know'}) do
    prepare_lang_tag(tag)
  end
end

function prepare_lang_tag(tag)
  local res = {
    list = {},
    len = 0,
    cur = nil,
    idx = 1,
  }

  for lang in string.gmatch(o[tag], "%S+") do
    if data['by_lang'][lang] then
      table.insert(res['list'], lang)
      res['len'] = res['len'] + 1
    end
  end
  res['cur'] = res['list'][1]
  data[tag] = res
end

function clear_ab_loop()
    mp.set_property("ab-loop-a", "no")
    mp.set_property("ab-loop-b", "no")
end

function set_ab_loop()
  if mp.get_property("ab-loop-a") ~= "no" then return ; end

  local a = mp.get_property("sub-start")
  local b = mp.get_property("sub-end")
  if a == nil or b == nil then return; end

  mp.set_property("ab-loop-a", a)
  mp.set_property("ab-loop-b", b)
end

function set_slang(tag)
  local lang = data[tag]['cur']

  if lang ~= nil then
    mp.set_property('sub', tonumber(data['by_lang'][lang]['id']))
  else
    mp.osd_message('Cant find sub with lang: ' .. o[tag])
  end
end

function cycle_lang_type(tag)
  local idx = data[tag]['idx']
  idx = idx + 1
  if idx > data[tag]['len'] then
    idx = 1
  end
  data[tag]['cur'] = data[tag]['list'][idx]
  data[tag]['idx'] = idx
end

function get_sub()
  local res = {}
  res['text'] = mp.get_property("sub-text")
  if res['text'] == "" or res['text'] == nil then return nil; end

  res['start'] = mp.get_property("sub-start")
  res['end'] = mp.get_property("sub-end")
  return res
end

function make_store_dir()
  mp.commandv("run", "mkdir", "-p", os['store_dir'])
end

function call_ext_script(sub)
  if o['script'] == "" then return ; end
  local filename = mp.get_property("filename")

  mp.commandv("run", o["script"], sub['text'], filename, sub['start'], sub['end'])
end

function save_sub(filename, sub)
  local fp = io.open(filename, "w")
  fp:write(sub['text'])
  fp:close()
  print("saved text to " .. filename)
end

function save_json(filename, sub)
  local str = utils.format_json(sub)
  if str == nil then
    print("Cant format json for sub: " .. sub)
    return
  end

  local fp = io.open(filename, "w")
  fp:write(str)
  fp:close()
  print("saved JSON to " .. filename)
end

function save_audio(filename, sub)
  local duration = sub['end'] - sub['start'] + 0.1

  local ffmpeg = get_ffmpeg()
  if ffmpeg == nil then
    print("Can't save audio: no ffmpeg")
    return
  end

  mp.commandv("run", ffmpeg, "-y",
              "-loglevel", "error",
              "-i", sub['source'],
              "-ss", sub['start'], "-t", duration,
              "-vn", "-ar", "44100", "-ac", "2",
              "-ab", "192k", "-f", "mp3", filename)
  print("saved audion to " .. filename)
end

local ffmpeg_path = nil
function get_ffmpeg()
  if ffmpeg_path == nil then
    local proc = io.popen("which ffmpeg")
    ffmpeg_path = proc:lines()()
    proc:close()
  end
  return ffmpeg_path
end
