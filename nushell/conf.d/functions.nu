# =============================================================================
# FUNCTIONS
# =============================================================================

def fnv [find?: string] {
    if ($find == null) {
        print "Usage: fnv <search_term>"
        return
    }

    if (which fd | is-empty) or (which fzf | is-empty) or (which nvim | is-empty) {
        print "Error: fnv requires fd, fzf, and nvim to be installed."
        return
    }

    let selected = (fd --hidden --exclude .git $find | fzf --preview 'bat --color=always --style=numbers {}' | str trim)
    if ($selected | is-not-empty) {
        nvim $selected
    }
}

def mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

def peek [pattern: string] {
  let files = (glob $pattern)
  let col = (open ($files.0) | columns | input list "select key")
  if ($col | is-empty) { return }
  $files | each {|f| {file: ($f | path basename), value: (open $f | get $col)}}
}

def drill [pattern: string] {
  let files = (glob $pattern)
  let sample = (open ($files.0))
  mut path_keys = []
  mut data = $sample
  loop {
    let type = ($data | describe)
    if ($type | str starts-with "record") or ($type | str starts-with "table") {
      let col = ($data | columns | input list "select key")
      if ($col | is-empty) { break }
      $path_keys = ($path_keys | append {kind: "key", val: $col})
      $data = ($data | get $col)
    } else if ($type | str starts-with "list") {
      let idx = (0..(($data | length) - 1) | each {|i| $"($i)"} | input list "select index")
      if ($idx | is-empty) { break }
      $path_keys = ($path_keys | append {kind: "index", val: $idx})
      $data = ($data | get ($idx | into int))
    } else {
      break
    }
  }
  let keys = $path_keys
  $files | each {|f|
    let val = ($keys | reduce -f (open $f) {|step, acc|
      if $step.kind == "index" {
        $acc | get ($step.val | into int)
      } else {
        $acc | get $step.val
      }
    })
    {file: ($f | path basename), value: $val}
  }
}
