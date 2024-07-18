package msg.seccamp2024

msg[{
	"channel": "notify-seccamp2024",
	"title": "Alert detected",
    "body": raw,
	"emoji": ":exclamation:",
}] {
	raw := base64.decode(input.body.message.data)
}
