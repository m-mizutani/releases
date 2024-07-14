package msg.google.pubsub.cloud_build

msg[{
	"channel": "build",
	"title": sprintf("Build finish: %s", [m.status]),
	"color": r.color,
	"emoji": r.emoji,
	"fields": [
		{
			"name": "Image",
			"value": sprintf("`%s`", [image]),
		},
		{
			"name": "Log",
			"value": "Link",
			"link": m.logUrl,
		},
	],
}] {
	raw := base64.decode(input.body.message.data)
	m := json.unmarshal(raw)
	image := m.images[_]

	r := {
		"QUEUED": {
			"color": "#FFA500",
			"emoji": ":hourglass_flowing_sand:",
		},
		"SUCCESS": {
			"color": "#2EB67D",
			"emoji": ":white_check_mark:",
		},
		"FAILURE": {
			"color": "#CB2431",
			"emoji": ":x:",
		},
		"INTERNAL_ERROR": {
			"color": "#FFA500",
			"emoji": ":warning:",
		},
		"TIMEOUT": {
			"color": "#FFA500",
			"emoji": ":warning:",
		},
		"CANCELLED": {
			"color": "#FFA500",
			"emoji": ":warning:",
		},
	}[m.status]
}
