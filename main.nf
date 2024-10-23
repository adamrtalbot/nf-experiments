include { validateParameters } from 'plugin/nf-validation'

process SLEEP {
    input:
        val time

    exec:
    sleep(time)
}

workflow {
    Channel.of(params.sleep * 1000)
    | SLEEP
    // Validate input parameters
    validateParameters()
}