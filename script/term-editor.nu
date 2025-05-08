#!/usr/bin/env nu

export def main [path: path, --alacritty(-a)] {
  if $alacritty {
    alacritty -e hx $path
  } else {
    ghostty -e hx $path
  }
}
