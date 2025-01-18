package route

import rego.v1

raw_body := input.data if {
	is_string(input.data)
} else := json.marshal(input.data) if {
	is_object(input.data)
} else := sprintf("%v", [input.data])

slack contains {
	"channel": "#xroute",
	"color": "#2EB67D",
	"emoji": ":satellite:",
	"title": "Incoming message",
	"body": substring(raw_body, 0, 512),
	"fields": [
		{
			"name": "Source",
			"value": input.source,
		},
		{
			"name": "schema",
			"value": input.schema,
		},
	]
} if {
	accepted
}

accepted if {
	input.auth.github.webhook.valid
}