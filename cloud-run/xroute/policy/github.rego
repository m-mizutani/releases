package route

import rego.v1

# GitHub Actions
slack contains {
    "channel": "#github-notify",
    "emoji": ":satellite:",
    "title": "GitHub Actions message",
    "body": input.body.message,
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

# New GitHub Issue other than myself
slack contains {
    "channel": "#github-notify",
    "emoji": ":newspaper:",
    "title": sprintf("New Issue: %s", [input.body.issue.title]),
    "body": input.body.issue.body,
    "fields": [
        {
            "name": "Repository",
            "value": input.body.repository.full_name,
            "link": input.body.repository.html_url,
        },
        {
            "name": "User",
            "value": input.body.sender.login,
            "link": input.body.sender.html_url,
        },
        {
            "name": "Issue",
            "value": input.body.issue.html_url,
        },
    ],
} if {
    input.auth.github.webhook.valid
    input.schema == "issue"
    input.body.action == "opened"
    input.body.sender.login != "m-mizutani"
}

# New GitHub Pull Request other than myself
slack contains {
    "channel": "#github-notify",
    "emoji": ":newspaper:",
    "title": sprintf("New Pull Request: %s", [input.body.pull_request.title]),
    "body": input.body.pull_request.body,
    "fields": [
        {
            "name": "Repository",
            "value": input.body.repository.full_name,
            "link": input.body.repository.html_url,
        },
        {
            "name": "User",
            "value": input.body.sender.login,
            "link": input.body.sender.html_url,
        },
        {
            "name": "Pull Request",
            "value": input.body.pull_request.number,
            "value": input.body.pull_request.html_url,
        },
    ],
} if {
    input.auth.github.webhook.valid
    input.schema == "pull_request"
    input.body.action == "opened"
    input.body.sender.login != "m-mizutani"
}

slack contains {
	"channel": "#github-notify",
	"color": "#2EB67D",
	"emoji": ":star:",
	"title": "Got star",
	"fields": [
		{
			"name": "Repository",
			"value": input.body.repository.full_name,
			"link": input.body.repository.html_url,
		},
		{
			"name": "User",
			"value": input.body.sender.login,
			"link": input.body.sender.html_url,
		},
	],
} if {
    input.auth.github.webhook.valid
	input.schema == "watch"
	input.body.action == "started"
}

# New GitHub package publish
slack contains {
    "channel": "#github-notify",
    "color": "#2EB67D",
    "emoji": ":package:",
    "title": "New package published",
    "fields": [
        {
            "name": "Repository",
            "value": input.body.repository.full_name,
            "link": input.body.repository.html_url,
        },
        {
            "name": "User",
            "value": input.body.sender.login,
            "link": input.body.sender.html_url,
        },
        {
            "name": "Package",
            "value": input.body.registry_package.package_version.package_url,
            "link": input.body.registry_package.package_version.package_url,
        },
    ],
} if {
    input.auth.github.webhook.valid
    input.schema == "registry_package"
    input.body.action == "published"
    input.body.registry_package.package_version.container_metadata.tag.name != ""
}
