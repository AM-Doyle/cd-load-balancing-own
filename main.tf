module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "lb-microservice-vpc"
  cidr = var.vpc_cidr_block

  azs             = var.availability_zones_euw
  private_subnets = var.privare_cidr
  public_subnets  = var.public_cidr

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_instance" {

  count = var.ec2_count

  source = "terraform-aws-modules/ec2-instance/aws"

  name = "lb-microservice-ec2-${count.index + 1}"

  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.ssg_sg.security_group_id, module.HTTP_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[count.index]
  ami                         = var.ami_id
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "ec2_private_instance" {

  source = "terraform-aws-modules/ec2-instance/aws"

  name = "lb-microservice-ec2-private-1"

  instance_type               = var.instance_type
  key_name                    = var.key_name
  monitoring                  = true
  vpc_security_group_ids      = [module.ssg_sg.security_group_id, module.HTTP_sg.security_group_id]
  subnet_id                   = module.vpc.private_subnets[0]
  ami                         = var.ami_id
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name            = "lb-microservice-lb"
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.ssg_sg.security_group_id, module.HTTP_sg.security_group_id]


    listeners = {
        sh_heating_li = {
            port = 80
            protocol = "HTTP"

            redirect ={
                port = 80
                protocol = "HTTP"
                path = "/api/login"
                status_code = "HTTP_301"
            }

            rules = {
                heating = {
                    actions = [{
                        type = "forward"
                        target_group_key = "sh_heating_tg"
                    }]

                    conditions = [{
                        path_pattern = {
                            values = ["/api/heating"]
                        }
                    }]
                }

                lights = {
                    actions = [{
                        type = "forward"
                        target_group_key = "sh_lights_tg"
                    }]

                    conditions = [{
                        path_pattern = {
                            values = ["/api/lights"]
                        }
                    }]
                }

                status = {
                    actions = [{
                        type = "forward"
                        target_group_key = "sh_status_tg"
                    }]

                    conditions = [{
                        path_pattern = {
                            values = ["/api/status"]
                        }
                    }]
                }

                auth = {
                    actions = [{
                        type = "forward"
                        target_group_key = "sh_auth_tg"
                    }]

                    conditions = [{
                        path_pattern = {
                            values = ["/api/auth", "/api/login"]
                        }
                    }]
                }
            }
        }
    }


  target_groups = {
    sh_heating_tg = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 3000
      target_type = "instance"

      health_check = {
        enabled  = true
        path     = "/healthcheck"
        protocol = "HTTP"
      }

      protocol_version = "HTTP1"
      target_id        = module.ec2_instance[0].id
      port             = 3000
    }

    sh_lights_tg = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 3000
      target_type = "instance"

      protocol_version = "HTTP1"
      target_id        = module.ec2_instance[1].id
      port             = 3000
    }

    sh_status_tg = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 3000
      target_type = "instance"

      protocol_version = "HTTP1"
      target_id        = module.ec2_instance[2].id
      port             = 3000
    }

    sh_auth_tg = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 3000
      target_type = "instance"

      health_check = {
        enabled  = true
        path     = "/healthcheck"
        protocol = "HTTP"
      }

      protocol_version = "HTTP1"
      target_id        = module.ec2_private_instance.id
      port             = 3000
    }
  }

  tags = {
    Environment = "Development"
  }
}