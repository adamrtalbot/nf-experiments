process FREEBAYES_PARALLEL {
    container 'quay.io/biocontainers/freebayes:1.3.7--h6a68c12_2'

    stageInMode 'copy'

    cpus 32
    memory '64GB'

    input:
        tuple val(id), path(bam), path(bai)
        tuple val(genome), path(fasta), path(fai)

    output:
        path 'out.vcf'

    script:
    """
    freebayes-parallel <(fasta_generate_regions.py ${fai} 100000) ${task.cpus} -f ${fasta} ${bam} > out.vcf
    """
}

workflow {
    bam   = Channel.fromFilePairs(params.bam + "{,.bai}", checkIfExists:true)
            .map { id, files -> tuple(id, files[0], files[1]) }
    fasta = Channel.fromFilePairs(params.fasta + "{,.fai}", checkIfExists:true)
            .map { id, files -> tuple(id, files[0], files[1]) }

    FREEBAYES_PARALLEL(bam, fasta)
}
