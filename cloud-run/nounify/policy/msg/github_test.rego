package msg.github

test_github_issue_open {
	resp := msg with input as {
        "header": {
            "X-Github-Event": "issues"
        },
        "body": data.msg.testdata.github_issue_open,
    }

    count(resp) > 0
    resp[x].channel == "github-notify"
    resp[x].fields[1].value == "#2: test issue"
}
