process MARKDUP_L {

    tag "${meta.name}"
    publishDir "${params.outdir}/QC/bamsormadup", pattern : "*.dup.txt", mode: 'copy', overwrite: true

    conda 'biobambam=2.0.183 samtools=1.18'

    input:
        tuple val(meta), path("in.cram")
        path ref_path

    output:
        tuple val(meta), path("${meta.name}.cram"), path("${meta.name}.cram.crai"), emit: cram
        path  "${meta.name}.txt"                                                  , emit: txt
        path  "${meta.name}.dup.txt"                                              , emit: dup
        path  "versions.yml"                                                      , emit: versions
        path "*.quilt"                                                            , emit: quilt

    script:
        """
        set pipefail -o
        touch ${task.process}_${meta.name}.quilt

        samtools view -T ${ref_path}/genome.fa -@ $task.cpus --no-PG -h in.cram > in.sam
        cat in.sam | bamsormadup inputformat=sam level=0 SO=coordinate blocksortverbose=0 rcsupport=1 threads=$task.cpus fragmergepar=$task.cpus optminpixeldif=2500 M=${meta.name}.dup.txt > ${meta.name}.sam
        samtools view -T ${ref_path}/genome.fa --no-PG -@ $task.cpus -C -o ${meta.name}.cram ${meta.name}.sam

        samtools quickcheck ${meta.name}.cram
        samtools index -@ $task.cpus ${meta.name}.cram

        ls *.dup.txt | xargs -i echo {} >> ${task.process}_${meta.name}.quilt

        #for multiqc
        cp "${meta.name}.dup.txt" "${meta.name}.txt"
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            bamsormadup: \$(bamsormadup -v 2>&1 | head -1 | sed 's/.*version //' | sed 's/\\.\$// ')
            samtools: \$(echo \$(samtools --version 2>&1) | head -1 | sed 's/^.*samtools //; s/Using.*\$//')
        END_VERSIONS
        """

    stub:
        """
        touch ${meta.name}.cram
        touch ${meta.name}.cram.crai
        touch ${meta.name}.dup.txt
        touch ${meta.name}.txt
        ls *.dup.txt | xargs -i echo {} >> ${task.process}_${meta.name}.quilt
        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            bamsormadup: \$(bamsormadup -v 2>&1 | head -1 | sed 's/.*version //' | sed 's/\\.\$// ')
            bammarkduplicatesopt: \$(bammarkduplicatesopt -v 2>&1 | head -1 | sed 's/.*version //' | sed 's/\\.\$// ')
            samtools: \$(echo \$(samtools --version 2>&1) | head -1 | sed 's/^.*samtools //; s/Using.*\$//')
        END_VERSIONS
        """
}

workflow {
    genome_ch  = Channel.fromPath(params.genome, type: 'dir', checkIfExists: true)
    cram_ch    = Channel.fromPath(params.cram, type: 'file', checkIfExists: true)
                  .map { cram -> tuple( ["name": "test"], cram ) }
    MARKDUP_L(cram_ch, genome_ch)
}