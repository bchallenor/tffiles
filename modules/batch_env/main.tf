provider "aws" {}

resource "aws_batch_compute_environment" "env" {
  compute_environment_name = "${var.name}"
  type                     = "MANAGED"

  service_role = "${aws_iam_role.service_role.arn}"

  compute_resources {
    type                = "SPOT"
    bid_percentage      = 40
    spot_iam_fleet_role = "${var.spotfleet_service_linked_role_arn}"

    instance_type = ["optimal"]
    instance_role = "${aws_iam_role.instance_role.arn}"

    min_vcpus = 0
    max_vcpus = "${var.max_vcpus}"

    subnets            = ["${data.aws_subnet.default.*.id}"]
    security_group_ids = ["${aws_security_group.sg.id}"]
  }
}
