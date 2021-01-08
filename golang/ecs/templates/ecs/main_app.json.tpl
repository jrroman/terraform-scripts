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
            "name": "AUTH0_CLIENT_ID",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/auth0_client_id"
        },
        {
            "name": "AUTH0_DOMAIN",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/auth0_domain"
        },
        {
            "name": "AUTH0_CLIENT_SECRET",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/auth0_client_secret"
        },
        {
            "name": "AUTH0_CALLBACK_URL",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/auth0_callback_url"
        },
        {
            "name": "AUTH0_DEV_API_IDENTIFIER",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/auth0_dev_api_identifier"
        },
        {
            "name": "AUTH0_DEV_API_ISSUER",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/auth0_dev_api_issuer"
        },
        {
            "name": "DB_HOST",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/db_host"
        },
        {
            "name": "DB_DRIVER",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/db_driver"
        },
        {
            "name": "DB_USER",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/db_user"
        },
        {
            "name": "DB_PASSWORD",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/db_password"
        },
        {
            "name": "DB_NAME",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/db_name"
        },
        {
            "name": "DB_PORT",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/db_port"
        },
        {
            "name": "SENDINBLUE_API_KEY",
            "valueFrom": "arn:aws:secretsmanager:${region}:100581657919:secret:${stage}/sendinblue_api_key"
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
