variable "AWS_PROFILE" {
  description = "Select profile from ~/.aws/credentials"
}

variable "ENV" {
  description = "Environment tag - useful for cost explorer"
}

variable "REGION" {
  description = "Create resource in which region"
}

variable "VPC_CIDR_BLOCK" {
  description = "VPC CIDR block"
}

variable "VPC_CIDR_SUBNET_PUB_1A" {
  description = "Subnet Public 1A CIDR Block"
}

variable "VPC_CIDR_SUBNET_PUB_1B" {
  description = "Subnet Public 1B CIDR Block"
}

variable "VPC_CIDR_SUBNET_PUB_1C" {
  description = "Subnet Public 1C CIDR Block"
}

variable "VPC_CIDR_SUBNET_PVT_1A" {
  description = "Subnet Private 1A CIDR Block"
}

variable "VPC_CIDR_SUBNET_PVT_1B" {
  description = "Subnet Private 1B CIDR Block"
}

variable "VPC_CIDR_SUBNET_PVT_1C" {
  description = "Subnet Private 1C CIDR Block"
}

variable "DB_INSTANCE_CLASS" {
  description = "RDS DB Instance Type - start small e.g. t3.micro"
}

variable "DB_PARAM_FAMILY" {
  description = "RDS DB Param Group Family - e.g. mysql5.7, mysql8.0"
}

variable "DB_ENGINE" {
  description = "DB Engine - e.g. mysql, or postgres"
}

variable "DB_ENGINE_VERSION" {
  description = "DB Engine Version - e.g. for mysql 5.7.28"
}

variable "DB_DISK_SIZE" {
  description = "DB Initial Disk Size - start small, but not less than 50GB"
}

variable "DB_DISK_SIZE_MAX" {
  description = "DB Disk Max Scaling Size - e.g. 100GB or 500GB?"
}

variable "DB_MASTER_PASSWORD" {
  description = "password for master user of your DB instance"
}

variable "AMI_WEB_SG" {
  description = "AMI for EC2 Web in particular region -- make sure your region is correct"
}

variable "EC2_INSTANCE_TYPE" {
  description = "EC2 instance type. e.g. t3a.micro"
}

variable "CLUSTER_NO" {
  description = "Number of cluster to create based on AZ"
}

variable "AZ_LIST" {
  description = "List of AZ to be created for cluster e.g ap-southeast-1a, ap-southeast-1b"
}

variable "VOL_TYPE" {
  description = "volume type. I suggest to use gp3 for better price (a bit pricey compared to gp2)"
}

variable "VOL_SIZE" {
  description = "volume size. Start small! we can always attach new EBS volume if the need arise"
}

variable "PROJECT_NAME" {
  description = "Name of the project"
}

variable "ENV_TAG" {
  description = "Env tag for the project"
}

variable "CREATE_EIP" {
  default     = false
  description = "If set to true, create an EIP for the service"
}

variable "EC2_COUNT" {
  description = "defines how many instance you want to create."
  default     = "1"
}

variable "DB_APP_PASSWORD" {
  description = "app password for project"
}
