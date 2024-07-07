package msg.aws.sns

test_sns_notification {
    resp := msg with input as data.msg.aws.test.sns_notification
    count(resp) > 0
}