provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./"
  vpc_id = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
}

//  module "fargate" {
//    source = "./fargate.tf"
//    vpc_id = module.network.vpc_id
//    public_subnet_id = module.network.public_subnet_id
//    private_subnet_id = module.network.private_subnet_id
//  }



