- "Create new Project" through the projects CLI, asks for the AWS API Key & Secret
  - Create a new AWS CodeCommit repo to host the terraform configuration template
  - Create a bucket with project metadata file
  - Register the Secrets in the AWS Secrets Manager, so it can be accessed by Hero Infra
  - Create a new Fargate Service to host the Hero Infra Web UI NextJS project
  - Redirect user to the Web UI
  - Later: Ensure the web app can only be access in a secure way
- "Create new Postgres Database"
  - Update the project manifest file to contain the changes made
  - Re-generate the terraform files and create a new commit to the TF repo
  - Run Terraform Apply


`docker build -t thimovss/hero-infra:0.0.1 .`
`docker run -p 8080:80 -d thimovss/hero-infra:0.0.1`
`docker push thimovss/hero-infra:0.0.1`


STEPS:
From a Docker CLI:
- [ ] Set up the S3 + DynamoDB back-end for terraform
- [ ] Set up the automated terraform deployment pipeline
- [ ] Create a minimal configuration for the project
- [ ] Run the generate script to create the terraform files
- [ ] Commit the first version of the terraform files to the CodeCommit repo

From the Web UI:
- [ ] Allow the user to press "New Service" & specify the docker image name to use & store in the project config
- [ ] Allow the user to press "apply", run the generate script, commit the changes to the CodeCommit repo
- [ ] Show the terraform apply status in the Web UI
