package auth

allow {
    input.path == "/msg/github"
    input.github.install_id == 52336960
}
