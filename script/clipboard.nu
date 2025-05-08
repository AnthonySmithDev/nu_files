#!/usr/bin/env -S nu --stdin

$env.CLIPBOARD_PATH = ($env.HOME | path join .clipboard)

def "main" [] {
  let stdin = $in
  $stdin | main write
  $stdin | main copy
}

def "main write" [] {
  try { save --force $env.CLIPBOARD_PATH }
}

def "main read" [] {
  try { open $env.CLIPBOARD_PATH }
}

def "main copy" [] {
  wl-copy
}

def "main paste" [] {
  wl-paste
}

def "main sync" [] {
  main paste | main write
}

def "main nc serv" [port: int] {
  try {
    nc -l -W 1 -p $port
  } catch {
    error make -u { msg: "Error starting clipboard server" }
  }
}

def "main nc post" [host: string, port: int] {
  try {
    nc $host $port
  } catch {
    error make -u { msg: "Error connecting to clipboard server" }
  }
}

def _sleep [] {
  try {
    sleep 250ms
  } catch {
    error make -u { msg: "Cancel" }
  }
}

def "main receiver" [
  --port: int = 12345
] {
  print "Start Receiver"
  mut last = ""
  loop {
    let clipboard = main nc serv $port
    if $clipboard == $last {
      _sleep
      continue
    }

    $clipboard | main write
    $clipboard | main copy

    print " - clipboard received"
    $last = $clipboard
  }
}

def "main r" [] { main receiver }

def "main watch" [
  --host: string = "anthony-desktop-work"
  --port: int = 12345
] {
  print "Start Watch"
  mut last = ""
  loop {
    let clipboard = main read
    if $clipboard == $last {
      _sleep
      continue
    }

    $clipboard | main nc post $host $port

    print " - clipboard send"
    $last = $clipboard
  }
}

def "main w" [] { main watch }
