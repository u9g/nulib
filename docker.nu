def "docker images" [] { docker image ls -a | from ssv --aligned-columns }
def "docker containers" [] { docker ps -a | from ssv --aligned-columns }

def "nu-complete image-names" [] { (docker images) | each { |e| { value: $e."IMAGE ID", description: $"repo: ($e.REPOSITORY), created: ($e.CREATED)" } } }

def del-image-and-containers-docker [image_name: string@"nu-complete image-names"] {
    (docker images) | where "IMAGE ID" == $image_name | each { |image|
        if $image.REPOSITORY != "<none>" {
            (docker containers) |
            where IMAGE == (if $image.TAG == "latest" { $image.REPOSITORY } else { $image.REPOSITORY + ':' + $image.TAG }) |
            each { |container|
                print $"Stopping container: ($container.NAMES)"
                print $"(ansi gb)> Output(ansi reset)"
                print (docker container stop ($container.NAMES) | lines | each { |e| "\t" + $e } | str join "\n")
                print $"(ansi rb)< Output(ansi reset)"
                print $"Deleting container: ($container.NAMES)"
                print $"(ansi gb)> Output(ansi reset)"
                print (docker container rm ($container.NAMES) | lines | each { |e| "\t" + $e } | str join "\n")
                print $"(ansi rb)< Output(ansi reset)"
            } | ignore
        }
        print $"Deleting image: ($image_name)"
        print $"(ansi gb)> Output(ansi reset)"
        docker image rm $image_name | lines | each { |e| "\t" + $e } | str join "\n"
        print $"(ansi rb)< Output(ansi reset)"
    }
}
