process DEMO {
    container 'quay.io/nf-core/ubuntu:20.04'

    input:
        path input_file

    output:
        stdout

    script:
    """
    cat ${input_file}
    """
}

workflow {
    input_ch = Channel.fromPath(params.input)
    DEMO(input_ch)
}