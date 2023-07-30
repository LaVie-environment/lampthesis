provider "aws" {
    region = "eu-west-2"
}

resource "aws_db_instance" "uat_db" {
    identifier_prefix    = "uat-up-and-running"
    allocated_storage    = 10
    db_name              = "uat_datastore"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    username             = "gacio"
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true

    password =
        data.aws_secretsmanager_secret_version.uat-db_password.secret_string
}

data "aws_secretsmanager_secret_version" "uat-db_password" {
  secret_id = "mysql-master-password-staging"
}