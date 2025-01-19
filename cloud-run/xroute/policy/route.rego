package route

import rego.v1

slack contains {
	"channel": "#xroute",
	"color": "#2EB67D",
	"emoji": ":satellite:",
	"title": "Incoming message",
	"body": substring(input.body, 0, 512),
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
	input.auth.github.webhook.valid
}
