package auth

allow {
    startswith(input.path, "/msg/github")
    input.auth.github.app.install_id == 933446
}

allow {
    startswith(input.path, "/msg/google")
    input.auth.google.email == "nounify-pusher@mztn-compute.iam.gserviceaccount.com"
}
