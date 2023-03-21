def nu-files-in-folder [] {
  ls | get name | where { |e| $e | str ends-with '.nu' }
}

def f [path:  string@nu-files-in-folder] {
  nufmt $path | lines | str join "\n" | save -f $path; cat $path 
}
