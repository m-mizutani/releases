package auth

test_seccamp2024 {
    resp := allow with input as data.auth.test.seccamp2024
    resp == true
}
