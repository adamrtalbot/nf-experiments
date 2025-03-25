workflow {  
    def secret = getSecret("rob-test-secret")
    log.info "Secret: $secret"
    SLEEP()
}

def getSecret(String secretName, String region = 'eu-west-2') {
    def client = com.amazonaws.services.secretsmanager.AWSSecretsManagerClientBuilder
        .standard()
        .withRegion(com.amazonaws.regions.Regions.fromName(region))
        .build()

    def getSecretValueRequest = new com.amazonaws.services.secretsmanager.model.GetSecretValueRequest()
        .withSecretId(secretName)

    try {
        def result = client.getSecretValue(getSecretValueRequest)
        return result.getSecretString()
    } catch (Exception e) {
        log.info "Failed to retrieve secret: ${e.message}"
        return null
    }
}

process SLEEP {
    script:
    """
    sleep 300
    """
}