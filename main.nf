process DEMO {
    container 'quay.io/nf-core/ubuntu:20.04'

    publishDir "${params.outdir}/${workflow.sessionId}"

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

    outdir = "${params.outdir}/${workflow.sessionId}"
    println "outdir: ${outdir}"
    input_ch.collectFile(keepHeader: true, storeDir: "${outdir}/csv")

}