function dlp
    set stack $argv[1]
    read -sP "Enter the pulumi stack passphrase for "$stack": " passphrase
    set -x PULUMI_CONFIG_PASSPHRASE $passphrase
    pulumi stack select UCB66D870DA/$stack
    aws-shib exec dladmin-ucboitlake$stack --
end
