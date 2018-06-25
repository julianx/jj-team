# Verify if Private Key does match certificate

CERT_KEY=rootCA.key
CERT_PEM=rootCA.pem

if [[ $(openssl rsa -noout -modulus -in ${CERT_KEY} | openssl md5 | awk '{print $NF}') -eq $(openssl x509 -noout -modulus -in ${CERT_PEM} | openssl md5 | awk '{print $NF}') ]]
then 
    echo "Private Key Matches a Certificate"
else 
    echo "Private Key Mismatch a Certificate"
fi
