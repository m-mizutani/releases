package auth.client

jwks_request(url) := http.send({
	"url": url,
	"method": "GET",
	"force_cache": true,
	"force_cache_duration_seconds": 3600,
}).raw_body

verify_google_jwt(header) := claims if {
	authValues := split(header, " ")
	count(authValues) == 2
	lower(authValues[0]) == "bearer"
	token := authValues[1]

	# Get JWKS of google
	jwks := jwks_request("https://www.googleapis.com/oauth2/v3/certs")

	# Verify token
	io.jwt.verify_rs256(token, jwks)
	claims := io.jwt.decode(token)
	print(claims[1])
	claims[1].iss == "https://accounts.google.com"
	time.now_ns() / ((1000 * 1000) * 1000) < claims[1].exp
}

allow if {
	claims := verify_google_jwt(input.header.Authorization)
	claims[1].email == "masayoshi.mizutani@dr-ubie.com"
}
