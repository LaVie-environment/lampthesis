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
    parameter_group_name = "default.mysql5.7"
    skip_final_snapshot  = true

    username             = "gacio"
    password             = "Comeback20"
}
