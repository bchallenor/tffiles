# These are convenient, but they can only be instantiated once per account

resource "aws_iam_service_linked_role" "spotfleet" {
  aws_service_name = "spotfleet.amazonaws.com"
}
