resource "aws_launch_configuration" "LC-Markov-kube-prod" {
  name = "Fmarkov-LC-kube-prod"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = "ssh-key"
 security_groups = ["${aws_security_group.instance_security_group.id}"]

  root_block_device {
    volume_size = 20
  }
}

resource "aws_elb" "ELB-Markov-kube-prod" {
  name = "ELB-Markov-kube-prod"
  security_groups = [aws_security_group.elb-security-group.id]
  subnets = [aws_subnet.private.id, aws_subnet.public.id]
  cross_zone_load_balancing = true
 health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 15
    target = "TCP:22"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "30080"
    instance_protocol = "http"
  }
  listener {
    lb_port = 3000
    lb_protocol = "http"
    instance_port = "30000"
    instance_protocol = "http"
  }
}

resource "aws_autoscaling_group" "ASG-Markov-kube-prod-master" {
  launch_configuration = aws_launch_configuration.LC-Markov-kube-prod.name
  vpc_zone_identifier = ["${aws_subnet.private.id}"]
  name = "Fmarkov-ASG-kube-prod-master"
  min_size = 3
  max_size = 3
  load_balancers = ["${aws_elb.ELB-Markov-kube-prod.name}"]
  health_check_type = "EC2"
  health_check_grace_period = 1200

  tag {
    key = "app"
    value = "prod"
    propagate_at_launch = true
  }
  tag {
    key = "role"
    value = "master_prod"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ASG-Markov-kube-prod-child" {
  launch_configuration = aws_launch_configuration.LC-Markov-kube-prod.name
  vpc_zone_identifier = ["${aws_subnet.private.id}"]
  name = "Fmarkov-ASG-kube-prod-child"
  min_size = 3
  max_size = 3
  load_balancers = ["${aws_elb.ELB-Markov-kube-prod.name}"]
  health_check_type = "EC2"
  health_check_grace_period = 1200

  tag {
    key = "app"
    value = "prod"
    propagate_at_launch = true
  }
  tag {
    key = "role"
    value = "child_prod"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}