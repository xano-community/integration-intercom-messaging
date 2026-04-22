function "intercom_create_contact" {
  description = "Create or update a contact/lead in Intercom"
  input {
    text role?="user" { description = "Contact role: user or lead" }
    email email? { description = "Contact email address" }
    text name? { description = "Contact full name" }
    text phone? { description = "Contact phone number" }
    text external_id? { description = "Your system's unique ID for this contact" }
    json custom_attributes? { description = "Custom attributes as key-value pairs" }
  }
  stack {
    var $params {
      value = {
        role: $input.role
      }
    }
    var.update $params { value = $params|set_ifnotnull:"email":$input.email }
    var.update $params { value = $params|set_ifnotnull:"name":$input.name }
    var.update $params { value = $params|set_ifnotnull:"phone":$input.phone }
    var.update $params { value = $params|set_ifnotnull:"external_id":$input.external_id }
    var.update $params { value = $params|set_ifnotnull:"custom_attributes":$input.custom_attributes }

    api.request {
      url = "https://api.intercom.io/contacts"
      method = "POST"
      headers = ["Authorization: Bearer " ~ $env.INTERCOM_ACCESS_TOKEN, "Content-Type: application/json", "Accept: application/json"]
      params = $params
      mock = {
        "creates contact successfully": { response: { status: 200, result: { type: "contact", id: "5f7a3c6e8b12c", role: "user", email: "jane@example.com", name: "Jane Doe", created_at: 1705312200 } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "Intercom API error: " ~ $api_result.response.result
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "creates contact successfully" {
    input = { email: "jane@example.com", name: "Jane Doe" }
    expect.to_not_be_null ($response.id)
    expect.to_equal ($response.email) { value = "jane@example.com" }
    expect.to_equal ($response.role) { value = "user" }
  }
}