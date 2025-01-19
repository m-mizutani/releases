package route

import rego.v1

slack contains {
	"channel": "#xroute",
	"color": "#2EB67D",
	"emoji": ":satellite:",
	"title": "Incoming message",
	"body": substring(base64.decode(input.body), 0, 512),
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
