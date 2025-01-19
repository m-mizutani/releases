package route

import rego.v1

slack contains {
    "channel": "#github-notify",
    "emoji": ":satellite:",
    "title": "GitHub Actions message",
    "body": input.data.message,
    "fields": fields,
} if {
	input.auth.github.actions.repository_owner == [
		"m-mizutani",
		"secmon-lab",
	][_]

    fields := [
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
    ]
}
