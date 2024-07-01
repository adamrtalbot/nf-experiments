include { validateParameters } from 'plugin/nf-validation'

workflow {
    // Validate input parameters
    validateParameters()
}