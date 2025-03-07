package route

import rego.v1

raw_body := base64.decode(input.body) if {
	is_string(input.body)
} else := json.marshal(input.body) if {
	is_object(input.body)
}

slack contains {
	"channel": "#xroute",
	"color": "#2EB67D",
	"emoji": ":satellite:",
	"title": "Incoming message",
	"body": sprintf("```\n%s```", [substring(raw_body, 0, 2048)]),
	"fields": [
		{
			"name": "Source",
			"value": input.source,
		},
		{
			"name": "Schema",
			"value": input.schema,
		},
	]
} if {
	accepted
}

accepted if {
	input.auth.github.actions.repository_owner == [
		"m-mizutani",
		"secmon-lab",
	][_]
}

accepted if {
	input.auth.github.webhook.valid
}
