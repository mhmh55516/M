#!/bin/bash

# Prompt user for domain name
read -p "Enter the domain name: " domain

# Generate private key
openssl genpkey -algorithm RSA -out "$domain.key" -aes256

# Generate CSR
openssl req -new -key "$domain.key" -out "$domain.csr" -subj "/CN=$domain"

# Generate self-signed certificate
openssl x509 -req -days 365 -in "$domain.csr" -signkey "$domain.key" -out "$domain.crt"

echo "Certificate and key generated successfully for $domain:"
ls -l "$domain.key" "$domain.csr" "$domain.crt"

mv "$domain.key" domain.key
mv "$domain.csr" domain.csr
mv "$domain.crt" domain.crt

echo "done"
exit 0
