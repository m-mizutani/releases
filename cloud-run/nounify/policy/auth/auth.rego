package auth

allow {
    startswith(input.path, "/msg/github")
    input.github.app.install_id == 52336960
}
