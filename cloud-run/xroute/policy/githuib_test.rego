package route

import rego.v1

test_github_actions if {
    resp := slack with input as data.testdata.github_actions

    count(resp) > 0
    resp[x].channel == "#github-notify"
    resp[x].emoji == ":satellite:"
    resp[x].title == "GitHub Actions message"
    resp[x].body == "Build and pushed image: ghcr.io/secmon-lab/alertchain:4861589c0c7a4463d5121d3cea83af9c69caa4bf"
    resp[x].fields[0].name == "Repository"
    resp[x].fields[0].value == "secmon-lab/alertchain"
    resp[x].fields[1].name == "Actor"
    resp[x].fields[1].value == "m-mizutani"
    resp[x].fields[2].name == "Workflow"
    resp[x].fields[2].value == "publish"
}
