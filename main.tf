module "network" {
  source = "./modules/network"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-west-1a", "us-west-1c"]

  tags = {
    Project = "ScalableInfra"
    Env     = "dev"
  }
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
  tags = {
    Project = "ScalableInfra"
    Env     = "dev"
  }
}
module "ec2" {
  source = "./modules/ec2"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  sg_id             = module.security.sg_id
  iam_role_arn      = module.security.iam_role_arn
  key_name          = "aws"                   # Your existing AWS key name
  ami_id            = "ami-04f34746e5e1ec0fe" 
  tags = {
    Project = "ScalableInfra"
    Env     = "dev"
  }
}

module "db" {
  source = "./modules/db"

  vpc_id            = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  sg_id             = module.security.sg_id
  db_username       = "admin"
  db_password       = "Jenkins8264"
  tags = {
    Project = "ScalableInfra"
    Env     = "dev"
  }
}

module "monitoring" {
  source       = "./modules/monitoring"
  instance_id  = module.ec2.instance_id
  db_identifier = module.db.rds_id
  alert_email  = "your-email@example.com"

  tags = {
    Project = "ScalableInfra"
    Env     = terraform.workspace
  }
}
