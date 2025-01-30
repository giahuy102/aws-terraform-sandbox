module "simple_vpc" {
  source      = "./modules/vpc"
  common_tags = var.common_tags
}

module "ec2_servers" {
  source             = "./modules/ec2"
  private_subnet_ids = module.simple_vpc.private_subnet_ids
  vpc_id             = module.simple_vpc.vpc_id
  common_tags        = var.common_tags
}
