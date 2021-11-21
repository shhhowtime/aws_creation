resource "aws_launch_configuration" "LC-Markov-gitlab" {
  name = "Fmarkov-LC-gitlab"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
  key_name = "ssh-key"
  security_groups = ["${aws_security_group.instance_security_group.id}"]

  root_block_device {
    volume_size = 20
  }

  user_data = <<-EOF
            #!/bin/bash
            sleep 1m

            mkdir /root/.ssh
            echo -e "${var.ssh_private_key}" > /home/ubuntu/.ssh/id_ed25519
            chown ubuntu:ubuntu /home/ubuntu/.ssh/id_ed25519
            chmod 0600 /home/ubuntu/.ssh/id_ed25519

            apt-get update
            apt-get install -y git python3 python3-pip
            pip3 install ansible
            
            git clone https://github.com/shhhowtime/gitlab.git
            cd gitlab
            echo "${var.secret}" > .pass.txt
            ansible-playbook -i inventory/prod main.yml
            cd ..

            git clone https://github.com/shhhowtime/kubespray.git
            cd kubespray
            echo "${var.secret2}" > .pass.txt
            chmod +x run_stage.sh
            ./run_stage.sh
            
            cd ..
            rm -rf /gitlab
            EOF
}

resource "aws_elb" "ELB-Markov-gitlab" {
  name = "ELB-Markov-gitlab"
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
    instance_port = "80"
    instance_protocol = "http"
  }
  listener {
    lb_port = 22
    lb_protocol = "tcp"
    instance_port = "22"
    instance_protocol = "tcp"
  }
  listener {
    lb_port = 2222
    lb_protocol = "tcp"
    instance_port = "2222"
    instance_protocol = "tcp"
  }
}

resource "aws_autoscaling_group" "ASG-Markov-gitlab" {
  launch_configuration = aws_launch_configuration.LC-Markov-gitlab.name
  vpc_zone_identifier = ["${aws_subnet.private.id}"]
  name = "Fmarkov-ASG-gitlab"
  min_size = 1
  max_size = 1
  load_balancers = ["${aws_elb.ELB-Markov-gitlab.name}"]
  health_check_type = "EC2"
  health_check_grace_period = 1800

  tag {
    key = "app"
    value = "gitlab"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}