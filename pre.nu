let GENERATED_FILE_NAME = 'main__pre_generated__.nu'
let GENERATED_COMMENT = '# GENERATED NULIB PATH'
let nu_path = (^which nu)

if ((open $nu.config-path | lines | find $GENERATED_COMMENT | length) == 0) {
    $"\nalias nu=\"\(pushd (pwd) > /dev/null && git pull -q && ($nu_path) ./pre.nu; popd > /dev/null) && ($nu_path)\"\n" | save -a ~/.bashrc
    "\n# GENERATED NULIB PATH\n" | save -a $nu.config-path
    $"source (pwd)/($GENERATED_FILE_NAME)\n" | save -a $nu.config-path
}


let IGNORED = [
      'pre.nu',
      $GENERATED_FILE_NAME
]

ls -f | where {
      |e| ($IGNORED | each { |ignore| ($e.name | str ends-with $ignore) } | all { not $in }) and ($e.name | str ends-with '.nu')
} | each {
      |e| $"source ($e.name)"
} | str join "\n" | save -f $GENERATED_FILE_NAME

"\n" | save -a $GENERATED_FILE_NAME
