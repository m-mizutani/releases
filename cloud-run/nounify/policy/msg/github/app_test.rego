package msg.github.app

test_github_issue_open {
	resp := msg with input as {
        "header": {
            "X-Github-Event": "issues"
        },
        "body": data.msg.testdata.github.issue_open,
    }

    count(resp) > 0
    resp[x].channel == "github-notify"
    resp[x].fields[1].value == "#2: test issue"
}

test_github_issue_open_by_own {
	resp := msg with input as {
        "header": {
            "X-Github-Event": "issues"
        },
        "body": data.msg.testdata.github.issue_open_by_own,
    }

    count(resp) == 0
}

test_pull_request_open {
    resp := msg with input as {
        "header": {
            "X-Github-Event": "pull_request"
        },
        "body": data.msg.testdata.github.pull_request,
    }

    count(resp) > 0
    resp[x].channel == "github-notify"
    resp[x].fields[1].value == "#3: Add health check endpoint"
}

test_star_created {
    resp := msg with input as {
        "header": {
            "X-Github-Event": "star"
        },
        "body": data.msg.testdata.github.star,
    }

    count(resp) > 0
    resp[x].channel == "github-notify"
    resp[x].fields[1].value == "AustinTI"
}