params.greetings = "hello,bonjour,hola"

process HELLO {
    input:
    val name

    output:
    stdout

    script:
    """
    echo "hello $name"
    """
}

workflow {
    names = channel.from(params.greetings.split(','))
    HELLO(names)
}