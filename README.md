# Simple Time Service

A microservice that provides time-related functionality, deployed on AWS infrastructure using Terraform.

## Project Overview

This project consists of two main components:
- A time service application
- AWS infrastructure managed by Terraform

The infrastructure is deployed in AWS using Terraform, with state management in S3 and DynamoDB for state locking.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Terraform](https://www.terraform.io/downloads.html) (>= 1.11.1)
- [AWS CLI](https://aws.amazon.com/cli/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (if you need to interact with the Kubernetes cluster)
- [Node.js](https://nodejs.org/) (for local development)
- [Docker](https://www.docker.com/) (for containerized local development)

## Infrastructure Details

The infrastructure is deployed with the following architecture:

### Network Architecture
- A VPC with:
  - 2 public subnets for internet-facing resources
  - 2 private subnets for internal resources
- Load balancer deployed in public subnets for external access
- EKS nodes deployed in private subnets for security

### Kubernetes Infrastructure
- An EKS cluster deployed within the VPC
- EKS service resource to run the application container
- Node groups configured in private subnets

### State Management
- S3 bucket for Terraform state management
- DynamoDB table for state locking
- State management details:
  - Bucket: `terraform-state-522814697098-us-east-2`
  - Key: `simple-time-service/terraform.tfstate`
  - Region: `us-east-2`
  - State locking is managed via DynamoDB table: `terraform-locks-522814697098`

## Local Development

### Running the Application Locally

1. Navigate to the app directory:
   ```bash
   cd app
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the application:
   ```bash
   npm start
   ```

   The application will start on `http://localhost:3000` by default.

### Running with Docker Locally

1. Build the Docker image:
   ```bash
   docker build -t simple-time-service .
   ```

2. Run the container:
   ```bash
   docker run -p 3000:3000 simple-time-service
   ```

   The application will be available at `http://localhost:3000`.

### Testing the Application

Once the application is running, you can test it by:
1. Opening a web browser and navigating to `http://localhost:3000`
2. Using curl:
   ```bash
   curl http://localhost:3000
   ```

The service will return the current time and your IP address.

## AWS Authentication

To deploy the infrastructure, you need to authenticate with AWS. There are two ways to do this:

### Option 1: AWS CLI Configuration
1. Install the AWS CLI
2. Run `aws configure`
3. Enter your AWS Access Key ID, Secret Access Key, default region (us-east-2), and output format (json)

### Option 2: Environment Variables
Set the following environment variables:
```bash
export AWS_ACCESS_KEY_ID="your_access_key_id"
export AWS_SECRET_ACCESS_KEY="your_secret_access_key"
export AWS_DEFAULT_REGION="us-east-2"
```

## Deployment Options

### Option 1: Manual Infrastructure Deployment

1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned changes:
   ```bash
   terraform plan
   ```

4. Apply the infrastructure:
   ```bash
   terraform apply
   ```

5. After the infrastructure is deployed, Terraform will output the load balancer endpoint. You can access the application using:
   ```bash
   http://<load-balancer-endpoint>
   ```
   
   For example, if the load balancer endpoint is `my-loadbalancer-1234567890.us-east-2.elb.amazonaws.com`, you would access the application at:
   ```
   http://my-loadbalancer-1234567890.us-east-2.elb.amazonaws.com
   ```

   You can also get the load balancer endpoint at any time by running:
   ```bash
   terraform output load_balancer_endpoint
   ```

   > **Note:** The load balancer may take 2-5 minutes to become fully operational after deployment. During this time, you might receive connection errors or timeouts. Please wait a few minutes and try accessing the endpoint again

### Option 2: Automated Deployment via CI/CD Pipeline

The project includes a GitHub Actions workflow that automates the deployment process. The pipeline consists of three main jobs:

1. **Docker Image Build & Push**
   - Builds the application Docker image
   - Pushes the image to Docker Hub
   - Tags the image with version v1.0.0

2. **Terraform Plan**
   - Initializes Terraform
   - Validates the configuration
   - Creates and saves a plan
   - Uploads the plan as an artifact

3. **Terraform Apply**
   - Downloads the saved plan
   - Applies the infrastructure changes
   - Only runs on main branch or manual trigger

#### Pipeline Triggers
- Automatic: On push to main branch
- Manual: Through GitHub Actions interface

#### Required Secrets
The pipeline requires the following secrets to be configured in your GitHub repository:
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token
- `AWS_ACCESS_KEY_ID`: AWS access key
- `AWS_SECRET_ACCESS_KEY`: AWS secret key

#### How to Use the Pipeline
1. Ensure all required secrets are configured in your GitHub repository
2. Push changes to the main branch to trigger automatic deployment
3. Or manually trigger the workflow through GitHub Actions interface

### Infrastructure Destruction

#### Option 1: Manual Destruction
1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Review what will be destroyed:
   ```bash
   terraform plan -destroy
   ```

3. Destroy the infrastructure:
   ```bash
   terraform destroy
   ```

   > **Warning:** This will permanently delete all AWS resources created by Terraform. 

#### Option 2: Pipeline-based Destruction
The project includes a separate GitHub Actions workflow for infrastructure destruction.

1. Navigate to the GitHub Actions tab in your repository
2. Select the "Destroy Terraform" workflow
3. Click "Run workflow" to trigger the destruction process

   > **Note:** The destruction workflow requires the same AWS credentials as the deployment workflow.

## Troubleshooting

If you encounter issues:
1. Check AWS credentials are properly configured
2. Verify you have the necessary IAM permissions
3. Ensure the S3 bucket and DynamoDB table exist
4. Check Terraform version compatibility
