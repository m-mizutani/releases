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
