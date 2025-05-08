#!/usr/bin/env -S nu --stdin

let ctx_directory = ($env.PWD | path join "ctx")
let hash_directory = ($ctx_directory | path join "hashes")

mkdir $hash_directory

def main [] {
  let user_input = ($in | str trim)
  let input_hash = ($user_input | hash md5)

  $user_input | save --force ($hash_directory | path join $input_hash)
}

def get-hashed-files [] {
  if ($hash_directory | path exists) {
    return (ls $hash_directory | get name)
  }
  return []
}

def "main show" [language: string = "txt"] {
  for $file_name in (get-hashed-files) {
    print ""
    bat --language $language --paging never --plain $file_name
    print ""
  }
}

def "main remove" [language: string = "txt"] {
  let hashed_files = get-hashed-files
  if ($hashed_files | is-not-empty) {
    let preview = $"bat --language ($language) --color=always --style=numbers {}"
    let selected = ($hashed_files | to text | fzf --reverse --style full --preview $preview)

    rm $selected
  }
}

def "main delete" [] {
  for $file_name in (get-hashed-files) {
    rm $file_name
  }
}

def "main editor" [] {
  if (get-hashed-files | is-not-empty) {
    hx $hash_directory
  }
}

def "main mods" [...rest] {
  let hashed_files = get-hashed-files
  if ($hashed_files | is-not-empty) {
    open ...$hashed_files | to text | mods ...$rest
  }
}

let watch_ask_prompt = r#'
Find the "AI" comments below (marked with ?) in the code files I've shared with you.
They contain my questions that I need you to answer and other instructions for you.
'#

def "main watch" [] {
  watch . --glob=**/*.go --quiet {|op, path|
    let prompt = (open $path | rg "AI?" | lines)
    if ($prompt | is-not-empty) {
      print $path
      open $path | aichat $watch_ask_prompt
    }
  }
}

# let watch_code_prompt = r#'
# I've written your instructions in comments in the code and marked them with "ai"
# You can see the "AI" comments shown below (marked with █).
# Find them in the code files I've shared with you, and follow their instructions.

# After completing those instructions, also be sure to remove all the "AI" comments from the code too.
# '#
