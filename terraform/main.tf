provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./network.tf"
}

module "fargate" {
  source = "./fargate"
  vpc_id = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
}