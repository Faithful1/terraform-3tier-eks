# --- root/main.tf ---

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 3
  max_subnets      = 4
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true
}

module "database" {
  source = "./database"
  db_storage = 10 #gibibites just 1024mb instead of 1000megabyts
  db_engine_version = "5.7.22"
  db_instance_class = "db.t2.micro"
  dbname = "josh"
  dbuser = "josh"
  dbpassword = "tellmeabout2021"
  db_identifier = "k3-db"
  skip_db_final_snapshot = true
  db_subnet_group_name = module.networking.db_subnet_group_name[0] //remember we only set one of this and it has to get only one
  vpc_security_group_ids = module.networking.db_security_group_id
}