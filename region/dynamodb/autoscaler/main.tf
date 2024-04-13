# Get the DynamoDB table here to apply autoscaling
data "aws_dynamodb_table" "table" {
  name = var.table_name
}

resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = var.max_read_capacity
  min_capacity       = var.min_read_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_policy" {
  name        = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.read_target.id}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.read_target.resource_id

  scalable_dimension = aws_appautoscaling_target.read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = var.read_target_utilization
  }
}

resource "aws_appautoscaling_target" "write_target" {
  max_capacity       = var.max_write_capacity
  min_capacity       = var.min_write_capacity
  resource_id        = "table/${var.table_name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_policy" {
  name        = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.write_target.id}"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.write_target.resource_id

  scalable_dimension = aws_appautoscaling_target.write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }

    target_value = var.write_target_utilization
  }
}