package auth.client

jwks_request(url) := http.send({
	"url": url,
	"method": "GET",
	"force_cache": true,
	"force_cache_duration_seconds": 3600,
}).raw_body

verify_google_jwt(token) := claims if {
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
	claims := verify_google_jwt(input.header.Token)
	claims[1].sub == [
		"110793906496191723686",
	][_]
}
