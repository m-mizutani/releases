package msg.google.pubsub.cloud_build

test_msg_google_pubsub_cloud_build {
    res := msg with input as {
        "body": data.msg.google.pubsub.test.cloud_build,
    }

    count(res) == 1
}
