process HELLO {
    container "docker.io/debian:stable-slim"

    script:
    "echo Hello world!"
}

workflow {
    HELLO()
}