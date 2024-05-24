# Hero Infra Setup Tool
Quickly get started using Hero Infra with the setup tool.

To use run, the following command:
```bash
docker run -it --rm thimovss/hero-infra-setup:0.0.1
```

An access key will be required, which you can find on the AWS console under
(IAM > Manage Access Keys)[https://us-east-1.console.aws.amazon.com/iam/home?region=eu-west-2#/security_credentials]

# For developers
Build the Docker image:
```bash
docker build --no-cache -t thimovss/hero-infra-setup:0.0.1 .
```