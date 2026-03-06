# Work with SSL Certificates

What we call SSL is actually TLS

SSL stands for "secure sockets layer"

TLS stands for "transport layer security"

TLS is an upgrade and it closed many security holes

SSL Certificates Authenticate the website and encrypt network traffic between the user and the website ... all data exchanged between the website is encrypted

The utility on linux that creates and manage tls certificates is called openssl 

Openssl can be used to create X.509 certificates ... these can be used on websites to do the authentication and encryption 

To learn about the commands that openssl supports type: 

#### openssl help

Standard commands:

req
x509

#### man openssl 
    tab 2x

#### man openssl req
#### man openssl-req

#### /EXAMPLE

## Certificate Signing Request (CSR)

the req subcommand deals with the certificate signing requests

the browser needs a way to trust the certificate ... know it's the real deal
 Certificate Authority needs to sign the cert with a special private key

#### openssl req -newkey rsa:2048 -keyout key.pem -out req.pem

on 2048 bits

#### $ ls
key.pem
req.pem

#### cat key.pem (base64 encoded)

## To generate a self-signed cert ... skip the csr and authority

#### -x509
-noenc
-newkey rsa:4096
-days 365
-keyout myprivate.key
-out mycertificate.crt

#### openssl req -x509 -noenc -newkey rsa:4096 -days 365 -keyout myprivate.key -out mycertificate.crt

#### openssl x509 -help

####    -text
 will print the cert in readable text form

####     -in
 tells openssl what input file to look at


#### openssl x509 -in mycertificate.crt -text

## Validity
    Not Before: when the cert was issued
    Not After: when it will expire

REMEMBER: if you need to get a cert you need to request something ... so you use the req subcommand

#### openssl help to get the list of subcommands

#### man openssl req

#### man openssl x509

ro6ert@ro6bx:~/Documents/LINUX/KodeKloud/SSL-Certificates$ ls
Certificate-Signing-Request-CSR-1.png
Clarification.png
CSR-2.png
CSR-3.png
custom-cert-1.png
custom-cert-2.png
custom-cert-3.png
custom-cert-4.png
custom-cert-5.png
custom-cert-6.png
custom-cert-7.png
custom-cert-8.png
Generating-a-Key-and-CSR.png
How-to-Create-TLS-SSL-Certificates-on-Linux-1.png
How-to-Create-TLS-SSL-Certificates-on-Linux-2.png
key.pem-req.pem.png
key-req.png
man-EXAMPLE.png
man-openssl-req.png
openssl-help.png
What-are-SSL-Certificates.png

