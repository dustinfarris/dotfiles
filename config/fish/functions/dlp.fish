function dlp
    set stack $argv[1]
    read -sP "Enter the pulumi stack passphrase for "$stack": " passphrase
    set -x PULUMI_CONFIG_PASSPHRASE $passphrase
    set -x AWS_REGION us-west-2
    pulumi stack select UCB66D870DA/$stack
    # saml2aws login --duo-mfa-option push --role  --force
    aws-shib exec dladmin-ucboitlake$stack --
end
