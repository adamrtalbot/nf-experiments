include { GATK4_CNNSCOREVARIANTS } from './modules/nf-core/gatk4/cnnscorevariants/main.nf'

workflow {

    input = [ [ id:'test' ], // meta map
        file("${params.test_data_base}/data/genomics/homo_sapiens/illumina/gvcf/test.genome.vcf.gz", checkIfExists: true),
        file("${params.test_data_base}/data/genomics/homo_sapiens/illumina/gvcf/test.genome.vcf.gz.tbi", checkIfExists: true),
        [],
        []
    ]
    fasta  = file("${params.test_data_base}/data/genomics/homo_sapiens/genome/genome.fasta", checkIfExists: true)
    fai    = file("${params.test_data_base}/data/genomics/homo_sapiens/genome/genome.fasta.fai", checkIfExists: true)
    dict   = file("${params.test_data_base}/data/genomics/sarscov2/genome/genome.dict", checkIfExists: true)
    GATK4_CNNSCOREVARIANTS ( input, fasta, fai, dict, [], [] )
}