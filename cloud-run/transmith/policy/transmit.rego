package transmit

import rego.v1

raw_body := input.data if {
    is_string(input.data)
} else := json.marshal(input.data) if {
    is_object(input.data)
} else := sprintf("%v", [input.data])

slack contains {
    "channel": "transmit",
    "color": "#2EB67D",
    "emoji": ":satellite:",
    "title": "Transmit message",
    "body": raw_body,
}
