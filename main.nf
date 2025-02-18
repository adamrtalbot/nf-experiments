workflow {
    Channel.fromPath(params.input)
        .splitCsv()
        .view()
}