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
