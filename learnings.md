
# Terraform Learnings

### providers

A provider is a terraform plugin that kows how to talk to a specific cloud platform(AWS,Azure,GCP, etc) it holds the configuration-like which region to deploy and which credentials to use. 

Normally we just need one provider. but if we want to create resources in different regions we need multiple providers for the same cloud. we can do this by using extra provider block with an alias, which is just a nickname. then you tell each resource which provider to use. 

### State Management 
when ran terraform plan / apply terraform creates a .tfstate and .tfstate.backup and some other files 

Desired state is what you want .tf files 
Actual state is what exists in AWS Real cloud resources 
what happpens during terraform plan/apply .tf files will be compared with .tfstate and determines changes needed 

### Remote Backend 
.tfstate files will contain sensitive data and need to store it in a remote backend like S3 because of advantages shared access for the team, state locking with S3, Versioning and Encrypted storage.

### Meta Arguments:

count: Create multiple resources with numeric indexing
eg : if we have list of strings say two s3 bucket names and if we say count = length(list_of_strings) in s3 bucket configuration we can access using count.index 

for_each: Create multiple resources with maps/sets
eg: general for loop we can iterate over it 
for_each = maps/sets name 
access it value using each.value 

depends_on: Explicit resource dependencies and there is also implicit dependency 
for explicit dependency we say depends_on parameter in the argument 
for implicit dependency we refer it with resource parameter say if we have vpc aws_resource.resource_name.id 

Life Cycle Rules: it actually controls how the resource is being created or updated or deleted it improves infrsstrructure management

Create_before_destroy: when we want to replace a resource without downtime we can use this parameter it creates new resource first and then deletes old resource

use cases: 
changing instance type of ec2 instance
resouces referenced by other resources

eg:

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

benefit: no downtime, enables blue-green deployment
when  not to use: when resource has dependencies that prevent simultaneous existence, cost considerations

prevent_destroy: prevents accidental deletion of critical resources

use cases: production databases, critical infrastructure components

eg:

resource "aws_db_instance" "example" {
    allocated_storage = 20
    engine  = "mysql"
    instance_class = "db.t2.micro"

    lifecycle {
        prevent_destroy = true
    }
}

benefit: safeguards against accidental deletions, prevents data loss

when not to use: when frequent resource replacements are necessary

ignore_changes: ignores specific attribute changes during updates

use cases: auto-scaling group size, dynamically assigned IP addresses

eg:

resource "aws_autoscaling_group" "app_servers" { 
  desired_capacity = 2

  lifecycle {
    ignore_changes = [
      desired_capacity,  # Ignore capacity changes by auto-scaling
      load_balancers,    # Ignore if added externally
    ]
  }
}


benefit: prevents unnecessary resource updates, maintains stability for certain attributes

when not to use: when all changes need to be tracked and managed

replace_triggered_by: forces resource replacement when specified dependencies change

use cases: resources dependent on external configurations, resources with specific version dependencies

eg:

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  lifecycle {
    replace_triggered_by = [
      aws_launch_template.example.id,  # Replace if launch template changes
    ]
  }
}

benefit: ensures resource consistency with dependencies, automates replacements based on changes

when not to use: when resource stability is preferred over automatic replacements

precondition: adds conditional checks before resource actions

use cases: enforcing compliance rules, validating configurations

eg:

resource "aws_s3_bucket" "example" {    
  bucket = "my-unique-bucket-name"

  lifecycle {
    precondition {
      condition     = length(var.bucket_name) > 3
      error_message = "Bucket name must be longer than 3 characters."
    }
  }
}

benefit: enforces rules before resource actions, prevents invalid configurations

when not to use: when no preconditions are necessary for resource management

postcondition: adds conditional checks after resource actions

use cases: validating resource states, ensuring compliance after creation

eg:

resource "aws_instance" "example" { 
    ami           = "ami-0c55b159cbfafe1f0"
    instance_type = "t2.micro"
    
    lifecycle {
        postcondition {
        condition     = self.instance_type == "t2.micro"
        error_message = "Instance type must be t2.micro after creation."
        }
    }
    }

benefit: ensures resource compliance after actions, validates final states

when not to use: when postconditions are not required for resource validation


common use cases for lifecycle rules:
1. Zero-downtime deployments: Using create_before_destroy for resources that require high availability.
2. Protecting critical resources: Using prevent_destroy for databases and essential infrastructure.
3. Managing dynamic attributes: Using ignore_changes for attributes that change outside of Terraform.
4. Ensuring resource consistency: Using replace_triggered_by for resources dependent on external configurations.
5. Enforcing configuration rules: Using precondition and postcondition for validating resource states.


### Conditional Expressions

What it does:
Evaluates a condition and returns one of two values based on whether the condition is true or false.

Syntax:
condition ? true_value : false_value

use cases:
1. Dynamic resource configuration: Adjusting resource parameters based on environment or other variables.
2. Conditional outputs: Displaying different output values based on certain conditions.
Example:
variable "environment" {
  description = "The deployment environment"
  type        = string
  default     = "dev"
} 
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.environment == "prod" ? "t2.large" : "t2.micro"
}

## Rule: Every variable used in .tfvars must be declared in variables.tf file

## Commands Used 
terraform init                             -  Initialize, download providers
terraform plan                             -  Preview changes
terraform apply                            -  Apply changes 
terraform destroy                          -  Delete all resources 
terraform state list                       - List resources in state
terraform state show <resource_name>       - Show detailed state information
terraform state rm <resource_name>         - Remove resource from state (without destroying)
terraform state mv <source> <destination>  - Move resource to different state address
terraform state pull                       - Pull current state and display
terraform state push                       - Push local state to remote backend