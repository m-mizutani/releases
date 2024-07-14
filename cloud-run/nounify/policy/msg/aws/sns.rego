package msg.aws.sns

msg[{
	"channel": "notify-aws",
	"color": "#FF9900",
	"emoji": ":incoming_envelope:",
	"title": "New subscription",
	"fields": [{
		"name": "Topic",
		"value": sprintf("`%s`", [input.body.TopicArn]),
	}],
}] {
	input.body.Type == "SubscriptionConfirmation"
	startswith(input.body.TopicArn, "arn:aws:sns:ap-northeast-1:783957204773:")
	http.send({
		"method": "GET",
		"url": input.body.SubscribeURL,
	})
}

msg[{
	"channel": "notify-aws",
	"emoji": ":incoming_envelope:",
	"title": input.body.Subject,
	"body": input.body.Message,
	"fields": [{
		"name": "Topic",
		"value": sprintf("`%s`", [input.body.TopicArn]),
	}],
}] {
	input.body.Type == "Notification"
}
