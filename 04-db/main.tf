module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "/${var.project_name}/${var.environment}"

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = "Transactions"   # project lo schema lo transactions kosam database use chesthunam
  port     = "3306"
  vpc_security_group_ids = data.aws_ssm_parameter.db_sg_id.value

  # DB subnet group
  #create_db_subnet_group = true        #true esthe automatic ga create chesthundi,already undi kabbati manully
  db_subnet_group_name = data.aws_ssm_parameter.db_subnet_group_name.value
  #subnet_ids             = ["subnet-12345678", "subnet-87654321"]  

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"
  manage_master_user_password = false
  password = "ExpenseApp1"
  skip_final_snapshot = true


  tags = merge(
    var.common_tags,
    {
        name = "${var.project_name}-${var.environment}"
    }
  )
  

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}