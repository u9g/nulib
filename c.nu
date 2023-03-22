def c [] { cd (ls | get name | str join "\n" | fzf) }
