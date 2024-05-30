module "db" {
  source = "../../terraform-expense-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB MySQL Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "db"
}

module "backend" {
  source = "../../terraform-expense-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB backend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "backend"
}

module "frontend" {
  source = "../../terraform-expense-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB frontend Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "frontend"
}

module "bastion" {
  source = "../../terraform-expense-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB bastion Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "bastion"
}

module "ansible" {
  source = "../../terraform-expense-securitygroup"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for DB ansible Instances"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "ansible"
}

# db is accepting connection from  backend 
resource "aws_security_group_rule" "db_backend" {    # terraform sg rule (db backend connection nunchi accept chesthundi)
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend.sg_id   # cidr kadhu source akkada nunchi vasthundi ani (backend)
  security_group_id = module.db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {    
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id   
  security_group_id = module.db.sg_id
}

# backend is accepting connection from  frontend 
resource "aws_security_group_rule" "backend_frontend" {   # ( backend frontend connection nunchi accept chesthundi)
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend.sg_id   # cidr kadhu source akkada nunchi vasthundi ani (frontend)
  security_group_id = module.backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {   
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id   
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_ansible" {   
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id   
  security_group_id = module.backend.sg_id
}

# backend is accepting connection from  public 
resource "aws_security_group_rule" "frontend_public" {    # (frontend public connection nunchi accept chesthundi)
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_bastion" {    
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}  
resource "aws_security_group_rule" "frontend_ansible" {    
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible.sg_id
  security_group_id = module.frontend.sg_id
}  

resource "aws_security_group_rule" "bastion_public" {    
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}  
resource "aws_security_group_rule" "ansible_public" {    
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ansible.sg_id
}  
