process PROCESS {
    debug true

    container "${input.container}"
    conda "${params.conda}"

    publishDir "${input.output}", pattern: "*", mode: "copy"

    input:
        val input
    
    output:
        path "**"                 , emit: allFiles, optional: true
        path "${input.outputGlob}", emit: output  , optional: true
        stdout

    script:
    """
    ${input.script}
    """
}

workflow {

    // Split the string, trim whitespace, and create file objects
    def fileObjects = params.input ?
                        params.input.split(',').collect { path -> files(path.trim(), checkIfExists: true, hidden: true) }.flatten() :
                        []

    input = Channel.of([
        "input": fileObjects,
        "output": params.output,
        "outputGlob": params.outputPattern,
        "container": params.container,
        "script": params.script,
    ])

    PROCESS(input)
}