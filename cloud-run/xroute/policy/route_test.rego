package route

test_sample if {
	resp := slack with input as {"data": {"foo": "bar"}}
	print(resp)
}
