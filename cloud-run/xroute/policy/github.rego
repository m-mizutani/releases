package route

import rego.v1

# GitHub Actions
slack contains {
    "channel": "#github-notify",
    "emoji": ":satellite:",
    "title": "GitHub Actions message",
    "body": input.data.message,
    "fields": [
        {
            "name": "Repository",
            "value": input.auth.github.actions.repository,
        },
        {
            "name": "Actor",
            "value": input.auth.github.actions.actor,
        },
        {
            "name": "Workflow",
            "value": input.auth.github.actions.workflow,
        },
    ],
} if {
	input.auth.github.actions.repository_owner == [
		"m-mizutani",
		"secmon-lab",
	][_]
}

# All GitHub Webhook Event
slack contains {
    "channel": "#github-notify",
    "emoji": ":octopus:",
    "title": sprintf("Event: %s %s", [input.schema, input.data.action]),
    "fields": [
        {
            "name": "Repository",
            "value": input.data.repository.full_name,
            "link": input.data.repository.html_url,
        },
        {
            "name": "User",
            "value": input.data.sender.login,
            "link": input.data.sender.html_url,
        },
    ],
} if {
    input.auth.github.webhook.valid
}

# New GitHub Issue other than myself
slack contains {
    "channel": "#github-notify",
    "emoji": ":newspaper:",
    "title": sprintf("New Issue: %s", [input.data.issue.title]),
    "body": input.data.issue.body,
    "fields": [
        {
            "name": "Repository",
            "value": input.data.repository.full_name,
            "link": input.data.repository.html_url,
        },
        {
            "name": "User",
            "value": input.data.sender.login,
            "link": input.data.sender.html_url,
        },
        {
            "name": "Issue",
            "value": input.data.issue.html_url,
        },
    ],
} if {
    input.auth.github.webhook.valid
    input.schema == "issue"
    input.data.sender.login != "m-mizutani"
}

# New GitHub Pull Request other than myself
slack contains {
    "channel": "#github-notify",
    "emoji": ":newspaper:",
    "title": sprintf("New Pull Request: %s", [input.data.pull_request.title]),
    "body": input.data.pull_request.body,
    "fields": [
        {
            "name": "Repository",
            "value": input.data.repository.full_name,
            "link": input.data.repository.html_url,
        },
        {
            "name": "User",
            "value": input.data.sender.login,
            "link": input.data.sender.html_url,
        },
        {
            "name": "Pull Request",
            "value": input.data.pull_request.number,
            "value": input.data.pull_request.html_url,
        },
    ],
} if {
    input.auth.github.webhook.valid
    input.schema == "pull_request"
    input.data.sender.login != "m-mizutani"
}