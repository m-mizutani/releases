package route

import rego.v1

test_github_actions if {
    resp := slack with input as data.testdata.github_actions

    count(resp) > 0

    resp[x].channel == "#xroute"
    resp[x].emoji == ":satellite:"
}

test_github_webhook_registry_package if {
    resp := slack with input as data.testdata.github_webhook.registry_package

    count(resp) > 0
    resp[_].channel == "#github-notify"
}

test_github_webhook_star if {
    resp := slack with input as data.testdata.github_webhook.star

    count(resp) > 0
    resp[_].channel == "#github-notify"
}
