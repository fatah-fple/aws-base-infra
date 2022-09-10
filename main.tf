## -----------------------
## Maintainer: FPLE DevOps
## Last Update: 2022-06-14
## ----------------------------

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Remote backends
terraform {
  backend "s3" {
    bucket                  = ""
    key                     = "<project-name>/terraform.tfstate"
    region                  = "ap-southeast-1"
    encrypt                 = true
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "default"
  }
}

provider "aws" {
  region  = "ap-southeast-1"
  profile = var.AWS_PROFILE
}

module "vpc" {
  source = "git::https://github.com/<orgsName>/aws-infra-vpc.git?ref=v1.0.0"

  VPC_CIDR_BLOCK         = var.VPC_CIDR_BLOCK
  REGION                 = var.REGION
  VPC_CIDR_SUBNET_PUB_1A = var.VPC_CIDR_SUBNET_PUB_1A
  VPC_CIDR_SUBNET_PUB_1B = var.VPC_CIDR_SUBNET_PUB_1B
  VPC_CIDR_SUBNET_PUB_1C = var.VPC_CIDR_SUBNET_PUB_1C
  VPC_CIDR_SUBNET_PVT_1A = var.VPC_CIDR_SUBNET_PVT_1A
  VPC_CIDR_SUBNET_PVT_1B = var.VPC_CIDR_SUBNET_PVT_1B
  VPC_CIDR_SUBNET_PVT_1C = var.VPC_CIDR_SUBNET_PVT_1C
  PROJECT_NAME           = var.PROJECT_NAME
}

module "ec2" {
  source = "git::https://github.com/<orgsName>/aws-infra-ec2.git?ref=v1.0.0"

  PROJECT_NAME      = var.PROJECT_NAME
  EC2_INSTANCE_TYPE = var.EC2_INSTANCE_TYPE
  AMI_WEB_SG        = var.AMI_WEB_SG
  ENV_TAG           = var.ENV_TAG
  ENV               = var.ENV
  SGWEB_ID          = module.security-group.sgweb_id
  SGCF_ID           = module.security-group.sg_cf_id
  VOL_TYPE          = var.VOL_TYPE
  VOL_SIZE          = var.VOL_SIZE
  CREATE_EIP        = var.CREATE_EIP
  EC2_COUNT         = var.EC2_COUNT
  PUBA_ID           = module.vpc.aws_subnet_pub_1a
  PUBB_ID           = module.vpc.aws_subnet_pub_1b
  PUBC_ID           = module.vpc.aws_subnet_pub_1c

}

module "rds" {
  source = "git::https://github.com/<orgsName>/aws-infra-rds.git//mysql?ref=v1.0.0" # pick either mysql or postgres

  PROJECT_NAME       = var.PROJECT_NAME
  DB_INSTANCE_CLASS  = var.DB_INSTANCE_CLASS
  DB_PARAM_FAMILY    = var.DB_PARAM_FAMILY
  DB_ENGINE          = var.DB_ENGINE
  DB_ENGINE_VERSION  = var.DB_ENGINE_VERSION
  DB_DISK_SIZE       = var.DB_DISK_SIZE
  DB_DISK_SIZE_MAX   = var.DB_DISK_SIZE_MAX
  DB_MASTER_PASSWORD = var.DB_MASTER_PASSWORD
  PVT_1a             = module.vpc.aws_subnet_pvt_1a
  PVT_1b             = module.vpc.aws_subnet_pvt_1b
  PVT_1c             = module.vpc.aws_subnet_pvt_1c
  SG_RDS_ID          = module.security-group.sg_rds_id
  DB_APP_PASSWORD    = var.DB_APP_PASSWORD
}

module "security-group" {
  source = "git::https://github.com/<orgsName>/aws-infra-secgroup.git?ref=v1.0.0"

  VPC_ID       = module.vpc.vpc_id
  PROJECT_NAME = var.PROJECT_NAME
}

module "redis" {
  source = "git::https://github.com/<orgsName>/aws-infra-redis.git?ref=v1.0.0"

  PROJECT_NAME       = var.PROJECT_NAME
  az_list            = var.AZ_LIST
  cache_no           = var.CLUSTER_NO
  redis_cluster_name = format("%s-%s", var.PROJECT_NAME, var.ENV)
  sg_group_id        = module.security-group.sg_redis_id
  subnet_group_name  = format("%s-%s", var.PROJECT_NAME, var.ENV)
  vpc_subnet_id      = [module.vpc.aws_subnet_pvt_1a, module.vpc.aws_subnet_pvt_1b, module.vpc.aws_subnet_pvt_1c]
}

