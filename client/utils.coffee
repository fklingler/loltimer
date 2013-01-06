time_string_from_minutes_and_seconds = (minutes, seconds) ->
  minutes = '0' + minutes if minutes < 10
  seconds = '0' + seconds if seconds < 10
  minutes + ':' + seconds

rgb_string_from_hash = (hash) ->
  "rgb(" + hash.red + "," + hash.green + "," + hash.blue + ")"

get_color_percent = (percent, initial, final) ->
  percent = 0 if percent < 0
  percent = 1 if percent > 1
  Math.floor(final - (1-percent)*(final - initial))

get_rgb_hash_percent = (percent, initial_hash, final_hash) ->
  red:   get_color_percent(percent, initial_hash.red, final_hash.red)
  green: get_color_percent(percent, initial_hash.green, final_hash.green)
  blue:  get_color_percent(percent, initial_hash.blue, final_hash.blue)

get_time_exp_percent = (actual, total) ->
  x = 1-actual/total
  PARAM = 1.5
  Math.exp(Math.exp(PARAM)*x-Math.exp(PARAM))