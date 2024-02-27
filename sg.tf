module "ssg_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name        = "ssh-sg"
  description = "Security group for web-server with ssh ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "HTTP_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "HTTP-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = module.ssg_sg.security_group_id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3000
  ip_protocol       = "tcp"
  to_port           = 3000
}

data "http" "myipaddr" {
  url = "http://icanhazip.com"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = module.ssg_sg.security_group_id

  cidr_ipv4   = "${chomp(data.http.myipaddr.response_body)}/32"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

// allows anything within the vpc to ssh into the ec2's
resource "aws_vpc_security_group_ingress_rule" "ssh_local" {
  security_group_id = module.ssg_sg.security_group_id

  cidr_ipv4   = "10.0.0.0/16"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}




# resource "aws_vpc_security_group_egress_rule" "outgoing_ipv6" {
#   security_group_id = module.ssg_sg.security_group_id

#   cidr_ipv6   = "::/0"
#   ip_protocol = "-1"
# }

# resource "aws_vpc_security_group_egress_rule" "outgoing_ipv4" {
#   security_group_id = module.ssg_sg.security_group_id

#   cidr_ipv4   = "0.0.0.0/0"
#   ip_protocol = "-1"
# }