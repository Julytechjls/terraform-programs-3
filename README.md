Here's a step-by-step README file for your Terraform project:

# Terraform AWS Practice

## Section 1: Creating Resources in AWS using Advanced Features

In this lab, we will create a series of resources in AWS using Terraform, and we will apply several advanced Terraform functions to manipulate data and configure our resources.

The functions we will use are:
* Numerical functions (`min`)
* String functions (`join`)
* Date and time functions (`formatdate`)
* IP network functions (`cidrsubnet`)

## Step 1: Initial Configuration

### 1.1. Terraform Installation

Make sure you have Terraform installed. You can follow the official instructions in the [Terraform documentation](https://learn.hashicorp.com/tutorials/terraform/install-cli).

## Step 2: Creating the Terraform Project

### 2.1. Project Structure

Create a directory for your Terraform project:

```sh
mkdir terraform-aws-practice
cd terraform-aws-practice
```

Inside this directory, create a `main.tf` file where we will define our resources.

## Step 3: Definition of Variables and Backend

### 3.1. Define Variables

Create a `variables.tf` file to define the variables we will use:

```hcl
provider "aws" {
  region = "us-east-1"  # Change this to your preferred region
}

variable "prefix" {
  description = "The prefix for resource names"
  type        = string
  default     = "devops"
}

variable "vpc_cidr" {
  description = "The CIDR range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
```

## Step 4: Create Resources Using Advanced Features

### 4.1. Numeric Function - min

Let's create a VPC and subnets using the `min` function to determine the minimum number of subnets to create:

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

locals {
  subnet_count = min(2, 3, 4)
}

resource "aws_subnet" "subnets" {
  count             = local.subnet_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "${var.prefix}-subnet-${count.index}"
  }
}
```

### 4.2. String Function - join

We will use the `join` function to create a concatenated name for our resources:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = join(", ", aws_subnet.subnets.*.id)
}
```

### 4.3. Date and Time Function - formatdate

We're going to use `formatdate` to create a label with the current date and time in a specific format:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-01b799c439fd5516a"
  instance_type = "t2.micro"

  tags = {
    Name      = "${var.prefix}-instance"
    CreatedAt = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  }
}
```

### 4.4. IP Network Function - cidrsubnet

We will use `cidrsubnet` to calculate additional subnets within our VPC:

```hcl
resource "aws_subnet" "additional_subnets" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 3)
  availability_zone = element(data.aws_availability_zones.available.names, count.index + 3)
  tags = {
    Name = "${var.prefix}-additional-subnet-${count.index}"
  }
}
```

## Step 5: Implementation and Verification

### 5.1. Initialize the Project

Initialize your Terraform project:

```sh
terraform init
```

### 5.2. Infrastructure Planning

Create a plan for your infrastructure:

```sh
terraform plan
```

### 5.3. Apply Settings

Apply the settings to create the resources in AWS:

```sh
terraform apply
```

Follow the prompts and type `yes` when asked to confirm the application.

---

This README provides a step-by-step guide to setting up and deploying AWS resources using Terraform, including advanced functions for manipulating data. Make sure to customize paths and variable values as needed for your specific environment and requirements.
