package route

test_sample if {
	resp := slack with input as {
		"source": "http://localhost:8080",
		"schema": "http",
		"data": {"foo": "bar"},
	}
	count(resp) == 1
}
