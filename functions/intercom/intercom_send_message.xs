function "intercom_send_message" {
  description = "Send an in-app message to a user via Intercom"
  input {
    text from_admin_id { description = "Intercom admin ID sending the message" }
    text to_contact_id { description = "Intercom contact ID to message" }
    text body { description = "Message body content" }
    text message_type?="inapp" { description = "Message type: inapp or email" }
    text subject? { description = "Email subject (required for email type)" }
  }
  stack {
    var $params {
      value = {
        message_type: $input.message_type,
        body: $input.body,
        from: { type: "admin", id: $input.from_admin_id },
        to: { type: "user", id: $input.to_contact_id }
      }
    }
    var.update $params { value = $params|set_ifnotnull:"subject":$input.subject }

    api.request {
      url = "https://api.intercom.io/messages"
      method = "POST"
      headers = ["Authorization: Bearer " ~ $env.INTERCOM_ACCESS_TOKEN, "Content-Type: application/json", "Accept: application/json"]
      params = $params
      mock = {
        "sends message successfully": { response: { status: 200, result: { type: "admin_message", id: "msg_abc123", message_type: "inapp", body: "Hello! How can we help?", created_at: 1705312200 } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "Intercom API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "sends message successfully" {
    input = { from_admin_id: "12345", to_contact_id: "5f7a3c6e8b12c", body: "Hello! How can we help?" }
    expect.to_not_be_null ($response.id)
    expect.to_equal ($response.message_type) { value = "inapp" }
  }
}