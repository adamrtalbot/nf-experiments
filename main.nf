process HELLO {
    container "docker.io/debian:stable-slim"

    script:
    "myscript.sh"
}

workflow {
    HELLO()
}