Ansible Setup for AWS and Cisco CSR 1000v

- need AWS SSH key for EC2 instance


Run command:

ansible-playbook aws-csr1000v.yml -v --private-key /FILE/PATH/AWS-PRIVATE.key


For SSH key access:
- ssh-keygen -t rsa -b 4096
- ssh-copy-id username@host
