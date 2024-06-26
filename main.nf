include { validateParameters; paramsHelp; paramsSummaryLog } from 'plugin/nf-schema'

workflow {
    // Validate input parameters
    validateParameters()
}