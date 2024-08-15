process PROCESS {
    debug true

    container "${meta.container}"
    conda "${meta.conda}"

    publishDir "${meta.output}", pattern: "*", mode: "copy"

    input:
        tuple path(inputs), val(meta)
    
    output:
        path "**"                , emit: allFiles, optional: true
        path "${meta.outputGlob}", emit: output  , optional: true
        stdout

    script:
    """
    ${meta.script}
    """
}

workflow {

    // Split the string, trim whitespace, and create file objects
    def fileObjects = params.input ?
                        params.input.split(',').collect { path -> files(path.trim(), checkIfExists: true, hidden: true) }.flatten() :
                        []

    input = Channel.of([
        fileObjects, 
        [
            output: params.output,
            outputGlob: params.outputPattern,
            container: params.container,
            script: params.script,
        ]
    ])

    PROCESS(input)
}