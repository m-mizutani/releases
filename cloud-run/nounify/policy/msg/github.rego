package msg.github

msg[{
  "channel": "github-notify",
  "color": "#2EB67D",
  "emoji": ":octopus:",
  "title": "New issue opened",
  "body": input.body.issue.body,
  "fields": [
    {
      "name": "Author",
      "value": input.body.issue.user.login,
      "link": input.body.issue.user.html_url,
    },
    {
      "name": "Issue",
      "value": sprintf("#%d: %s", [input.body.issue.number, input.body.issue.title]),
      "link": input.body.issue.html_url,
    },
  ],
}] {
  input.header["X-Github-Event"] == "issues"
  input.body.action == "opened"

  # Ignore myself
  input.body.issue.user.login != "m-mizutani"
}

msg[{
  "channel": "github-notify",
  "color": "#2EB67D",
  "emoji": ":octopus:",
  "title": "New PR opened",
  "body": input.body.pull_request.body,
  "fields": [
    {
      "name": "Author",
      "value": input.body.pull_request.user.login,
      "link": input.body.pull_request.user.html_url,
    },
    {
      "name": "Issue",
      "value": sprintf("#%d: %s", [input.body.pull_request.number, input.body.pull_request.title]),
      "link": input.body.pull_request.html_url,
    },
  ],
}] {
  input.header["X-Github-Event"] == "pull_request"
  input.body.action == "opened"

  # Ignore myself
  input.body.pull_request.user.login != "m-mizutani"
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
  input.header["X-Github-Event"] == "star"
  input.body.action == "created"
}
