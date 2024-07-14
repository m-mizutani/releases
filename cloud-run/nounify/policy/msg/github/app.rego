package msg.github.app

github_event := input.header["X-Github-Event"]

issue_entity := input.body.issue {
  github_event == "issues"
} else := input.body.pull_request {
  github_event == "pull_request"
}

msg[{
  "channel": "github-notify",
  "color": "#2EB67D",
  "emoji": ":octopus:",
  "title": sprintf("New %s opened", [github_event]),
  "body": issue_entity.body,
  "fields": [
    {
      "name": "Author",
      "value": issue_entity.user.login,
      "link": issue_entity.user.html_url,
    },
    {
      "name": "Link",
      "value": sprintf("#%d: %s", [issue_entity.number, issue_entity.title]),
      "link": issue_entity.html_url,
    },
  ],
}] {
  input.body.action == "opened"

  # Ignore myself
  issue_entity.user.login != "m-mizutani"
}

msg[{
  "channel": "github-notify",
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
}] {
  github_event == "star"
  input.body.action == "created"
}
