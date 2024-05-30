module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "/${var.project_name}/${var.environment}"

  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = "subnet-eddcdzz4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}