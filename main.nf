process HELLO {

    input:
    val identifier

    output:
    val identifier

    script:
    """
    echo $identifier
    """

}

workflow {
    Channel.from('hello')
    | HELLO
}