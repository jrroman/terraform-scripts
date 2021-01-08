[
  {
    "name": "${app_name}",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/${product_name}",
          "awslogs-region": "${region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "environment": [
        { "name": "NODE_ENV", "value": "production" },
        { "name": "RAILS_ENV", "value": "${stage}" },
        { "name": "RAILS_MASTER_KEY", "value": "${master_key}" },
        { "name": "RAILS_SERVE_STATIC_FILES", "value": "true" }
    ],
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]
