package route

import rego.v1

sample_msg := {
	"source": "github",
	"schema": "webhook",
	"data": data.testdata.sample,
	"auth": {
		"github": {
			"webhook": {
				"valid": true,
			}
		}
	}
}

test_sample if {
	resp := slack with input as {
		"source": "github",
		"schema": "webhook",
		"data": data.testdata.sample,
		"auth": {
			"github": {
				"webhook": {
					"valid": true,
				}
			}
		}
	}
	count(resp) == 1
	resp[x].channel == "#xroute"
	resp[x].color == "#2EB67D"
}

test_sample_invalid if {
	resp := slack with input as json.patch(sample_msg, [
		{"op": "replace", "path": "/auth/github/webhook/valid", "value": false}
	])
	count(resp) == 0
}