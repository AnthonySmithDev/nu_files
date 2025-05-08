#!/usr/bin/env nu

const BUTTON = {
  BACK: "70 150"

  PROFILE: "1000 1100"
  LIKE: "1000 1300"
  COMMENT: "1000 1450"
  BOOKMARK: "1000 1650"
  SHARED: "1000 1800"
  AUDIO: "1000 2000"

  UNLIKE: "280 1850"
  DOWNLOAD: "450 1850"
}

const TOP = {
  LEFT: "100 500"
  CENTER: "500 500"
  RIGHT: "1000 500"
}

const CENTER = {
  LEFT: "200 1000"
  CENTER: "500 1000"
  RIGHT: "800 1000"
}

const BOTTOM = {
  LEFT: "100 1500"
  CENTER: "500 1500"
  RIGHT: "1000 1500"
}

const KEYCODE = {
  POWER: 'KEYCODE_POWER'
  SLEEP: 'KEYCODE_SLEEP'
  VOLUME_UP: 'KEYCODE_VOLUME_UP'
  VOLUME_DOWN: 'KEYCODE_VOLUME_DOWN'
  VOLUME_MUTE: 'KEYCODE_VOLUME_MUTE'
  VOLUME_NEXT: 'KEYCODE_VOLUME_NEXT'
  VOLUME_PREVIOUS: 'KEYCODE_VOLUME_PREVIOUS'
  VOLUME_PLAY_PAUSE: 'KEYCODE_VOLUME_PLAY_PAUSE'
}

export def "main" [] {}

export def "main back" [] {
  adb shell input tap $BUTTON.BACK
}

export def "main profile" [] {
  adb shell input tap $BUTTON.PROFILE
}

export def "main like" [] {
  adb shell input tap $BUTTON.LIKE
}

export def "main comment" [] {
  adb shell input tap $BUTTON.COMMENT
}

export def "main bookmark" [] {
  adb shell input tap $BUTTON.BOOKMARK
}

export def "main shared" [] {
  adb shell input tap $BUTTON.SHARED
}

export def "main audio" [] {
  adb shell input tap $BUTTON.AUDIO
}

export def "main swipe left" [] {
  adb shell input swipe $CENTER.LEFT $CENTER.RIGHT 100
}

export def "main swipe down" [] {
  adb shell input swipe $BOTTOM.CENTER $TOP.CENTER 100
}

export def "main swipe up" [] {
  adb shell input swipe $TOP.CENTER $BOTTOM.CENTER 100
}

export def "main swipe right" [] {
  adb shell input swipe $CENTER.RIGHT $CENTER.LEFT 100
}

export def "main fast" [] {
  adb shell input swipe $CENTER.RIGHT $CENTER.RIGHT 10000
}

export def "main tap" [] {
  adb shell input tap $CENTER.CENTER
}

export def "main dtap" [] {
  adb shell input tap $CENTER.CENTER
  sleep 100ms
  adb shell input tap $CENTER.CENTER
}

export def "main unlike" [] {
  adb shell input swipe $CENTER.CENTER $CENTER.CENTER 1000
  sleep 500ms
  adb shell input tap $BUTTON.UNLIKE
}

export def "main download" [] {
  adb shell input swipe $CENTER.CENTER $CENTER.CENTER 1000
  sleep 500ms
  adb shell input tap $BUTTON.DOWNLOAD
}

export def "main power" [] {
  adb shell input keyevent $KEYCODE.POWER
}

export def "main sleep" [] {
  adb shell input keyevent $KEYCODE.SLEEP
}

export def "main volumen up" [] {
  adb shell input keyevent $KEYCODE.VOLUME_UP
}

export def "main volumen down" [] {
  adb shell input keyevent $KEYCODE.VOLUME_DOWN
}

export def "main volumen mute" [] {
  adb shell input keyevent $KEYCODE.VOLUME_MUTE
}

export def "main media next" [] {
  adb shell input keyevent $KEYCODE.MEDIA_NEXT
}

export def "main media previous" [] {
  adb shell input keyevent $KEYCODE.MEDIA_PREVIOUS
}

export def "main media play" [] {
  adb shell input keyevent $KEYCODE.MEDIA_PLAY_PAUSE
}

export def "main terminal" [] {
  wezterm
  # ghostty
  # alacritty
  # flatpak run com.raggesilver.BlackBox
}

export def "main files" [] {
  nautilus
}

export def "main scrcpy audio" [] {
  scrcpy --no-window
}

let global_args = [
  --max-size=1600
  --window-title='Tiktok'
  --window-borderless
  --turn-screen-off
  --keyboard=uhid
]

export def "main scrcpy tiktok" [] {
  let local_args = [
    # --new-display
    --start-app=?tiktok
    # --no-vd-destroy-content
  ]
  scrcpy ...$local_args ...$global_args
}

export def "main scrcpy borderless" [] {
  scrcpy ...$global_args
}
