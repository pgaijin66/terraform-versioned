resource "aws_ecr_repository" "this" {
  name = var.name

  image_tag_mutability = "MUTABLE"
  force_delete         = var.force_delete

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    terraform         = "true"
    Name              = var.name
    "capsule:team"    = var.capsule_team
    "capsule:service" = var.capsule_service
  }
}

resource "aws_ecr_lifecycle_policy" "expire_after_thirty_days_keep_latest" {
  count      = var.expire_after_30_days ? 1 : 0
  repository = aws_ecr_repository.this.name

  policy = <<EOF
{
  "rules": [
      {
        "rulePriority": 1,
        "description": "Keep thirty of prod",
        "selection": {
            "tagStatus": "tagged",
            "tagPrefixList": ["prod"],
            "countType": "imageCountMoreThan",
            "countNumber": 30
        },
        "action": {
            "type": "expire"
        }
      },
      {
        "rulePriority": 2,
        "description": "Expire images that 30 days or older",
        "selection": {
            "tagStatus": "any",
            "countType": "sinceImagePushed",
            "countUnit": "days",
            "countNumber": 30
        },
        "action": {
            "type": "expire"
        }
      }
  ]
}
EOF
}

data "aws_iam_policy_document" "allow_cross_account" {
  statement {
    actions = ["ecr:*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::874873923888:root",
      ]
    }
  }

  statement {
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
    ]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::036483606784:root",
        "arn:aws:iam::182893797880:root",
      ]
    }
  }

  statement {
    actions = [
      "ecr:BatchGetImage",
      "ecr:DeleteRepositoryPolicy",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:SetRepositoryPolicy",
    ]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_ecr_repository_policy" "allow_cross_account" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.allow_cross_account.json
}
