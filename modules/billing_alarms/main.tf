resource "aws_sns_topic" "billing" {
  name = "NotifyMe"
}

resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name          = "BillingAlarm-${element(var.thresholds, count.index)}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "${6*60*60}"
  statistic           = "Maximum"
  threshold           = "${element(var.thresholds, count.index)}"
  count               = "${length(var.thresholds)}"

  dimensions {
    Currency = "USD"
  }

  alarm_actions = [
    "${aws_sns_topic.billing.arn}",
  ]
}
