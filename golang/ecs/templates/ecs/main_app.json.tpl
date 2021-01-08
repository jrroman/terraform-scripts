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
    "secrets": [
        {
            "name": "DB_HOST",
            "valueFrom": "arn:aws:secretsmanager:${region}:AWS_ACCOUNT_ID:secret:${stage}/db_host"
        },
        {
            "name": "DB_DRIVER",
            "valueFrom": "arn:aws:secretsmanager:${region}:AWS_ACCOUNT_ID:secret:${stage}/db_driver"
        },
        {
            "name": "DB_USER",
            "valueFrom": "arn:aws:secretsmanager:${region}:AWS_ACCOUNT_ID:secret:${stage}/db_user"
        },
        {
            "name": "DB_PASSWORD",
            "valueFrom": "arn:aws:secretsmanager:${region}:AWS_ACCOUNT_ID:secret:${stage}/db_password"
        },
        {
            "name": "DB_NAME",
            "valueFrom": "arn:aws:secretsmanager:${region}:AWS_ACCOUNT_ID:secret:${stage}/db_name"
        },
        {
            "name": "DB_PORT",
            "valueFrom": "arn:aws:secretsmanager:${region}:AWS_ACCOUNT_ID:secret:${stage}/db_port"
        }
    ],
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]
