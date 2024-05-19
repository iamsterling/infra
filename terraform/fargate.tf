variable "vpc_id" {
  description = "The ID of the VPC"
}

variable "public_subnet_id" {
  description = "The ID of the public subnet"
}

variable "private_subnet_id" {
  description = "The ID of the private subnet"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ECSSecurityGroup"
  }
}

resource "aws_ecs_cluster" "main" {
  name = "my-cluster"

  tags = {
    Name = "MyECSCluster"
  }
}

resource "aws_ecs_task_definition" "helloworld_task" {
  family                   = "helloworld-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "helloworld"
      image     = "strm/helloworld-http:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name = "HelloWorldTaskDefinition"
  }
}

resource "aws_ecs_service" "helloworld_service" {
  name            = "helloworld-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.helloworld_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.public_subnet_id]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  tags = {
    Name = "HelloWorldService"
  }
}
