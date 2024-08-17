provider "aws" {
  region  = "ap-southeast-3"
  version = "~> 3.0"
}

resource "aws_db_instance" "postgres" {
  identifier            = "viking-nonprod"
  engine                = "postgres"
  engine_version        = "15"
  instance_class        = "db.t2.medium"
  username              = "app"
  password              = "red1KruPassW0w"
  allocated_storage     = 20
  backup_retention_period = 7
  multi_az              = false
  vpc_security_group_ids = [
    aws_security_group.redikru_db_instance_sg.id,
  ]
}
