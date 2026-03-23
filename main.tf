module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
}

module "igw" {
  source = "./modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat" {
  source        = "./modules/nat"
  public_subnet = module.subnets.public_subnets[0]
}

module "routes" {
  source = "./modules/route-tables"

  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
  nat_id = module.nat.nat_id

  public_a = module.subnets.public_subnets[0]
  public_b = module.subnets.public_subnets[1]

  app_a = module.subnets.app_subnets[0]
  app_b = module.subnets.app_subnets[1]
}