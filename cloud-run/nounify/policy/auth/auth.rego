package auth

allow {
	input.path == "/msg/github/app"
	input.auth.github.app.install_id == 933446
}

allow {
	startswith(input.path, "/msg/google")
	input.auth.google.email == "nounify-pusher@mztn-compute.iam.gserviceaccount.com"
}

allow {
	startswith(input.path, "/msg/aws")
	startswith(input.auth.aws.sns.TopicArn, "arn:aws:sns:ap-northeast-1:783957204773:")
}
