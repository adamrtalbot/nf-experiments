process DEMO {
    container 'quay.io/nf-core/ubuntu:20.04'

    publishDir "${params.output}"

    input:
        path input_file

    output:
        path "output.txt"

    script:
    """
    cat ${input_file} > output.txt
    """
}

workflow {
    input_ch = Channel.fromPath(params.input)
    DEMO(input_ch)
}