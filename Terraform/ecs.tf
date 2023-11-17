module "ecs" {
  source       = "terraform-aws-modules/ecs/aws"
  version      = "5.6.0"
  cluster_name = "ecs-lab"
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }
}
# ---------------------------------------
#data "aws_iam_role" "ecs_task_execution_role" { name = "ecsTaskExecutionRole" }

resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode([{
    essential    = true,
    image        = "nginx:latest",
    name         = "web-app",
    portMappings = [{ containerPort = 80 }],
  }])
  cpu = 256
  #execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  family                   = "web-app-tasks"
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "this" {
  cluster         = module.ecs.cluster_id
  desired_count   = 2
  launch_type     = "FARGATE"
  name            = "web-app-service"
  task_definition = aws_ecs_task_definition.this.arn

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    container_name = "web-app"
    container_port = 80
    #target_group_arn = module.alb.target_group_arns[0]
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  network_configuration {
    security_groups = [module.vpc.default_security_group_id, aws_security_group.allow_http.id]
    subnets         = module.vpc.private_subnets
  }
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

