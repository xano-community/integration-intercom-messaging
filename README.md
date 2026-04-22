# Intercom Integration for Xano

Manage contacts and send in-app messages through Intercom from your Xano backend. Automate user onboarding, engagement, and support communication workflows.

## Functions

| Function | Description |
| --- | --- |
| `intercom_create_contact` | Creates or updates a contact or lead in Intercom. |
| `intercom_send_message` | Sends an in-app message to a user in Intercom. |

## Install

### Option A — Ask Claude Code

With the [Xano MCP](https://github.com/xano-labs/mcp-server) enabled in Claude Code, paste this into Claude:

> Install the integration at https://github.com/xano-community/integration-intercom-messaging into my Xano workspace.

Claude will clone the repo and push the functions to your workspace.

### Option B — Use the Xano CLI

1. Install and authenticate the [Xano CLI](https://docs.xano.com/cli):
   ```sh
   npm install -g @xano/cli
   xano auth
   ```

2. Clone and push this integration:
   ```sh
   git clone https://github.com/xano-community/integration-intercom-messaging.git
   cd integration-intercom-messaging
   xano workspace:push . -w <your-workspace-id>
   ```

   Replace `<your-workspace-id>` with the ID from `xano workspace:list`.

## Configure Credentials

1. Log in to your Intercom workspace at https://app.intercom.com.
2. Navigate to Settings > Integrations > Developer Hub.
3. Create a new app or select an existing one.
4. Go to Authentication and copy your Access Token.
5. In Xano, set the environment variable INTERCOM_ACCESS_TOKEN to your access token.

Environment variables used by this integration:

- `INTERCOM_ACCESS_TOKEN`

See `.env.example` for a template.

## Usage

Call any function from another function, task, or API endpoint using `function.run`:

```xs
function.run "intercom_create_contact" {
  input = {
    // See function signature for required parameters
  }
} as $result
```

## Function Reference

### `intercom_create_contact`

Adds a new contact to your Intercom workspace with details such as email, name, and custom attributes. If a contact with the same email already exists, it updates the existing record. Ideal for syncing user sign-ups or profile changes from your application into Intercom automatically.

### `intercom_send_message`

Delivers an in-app message to a specific user identified by their Intercom contact ID. Supports plain text and rich content for targeted communication. Use this to send onboarding tips, feature announcements, or personalized notifications triggered by user actions in your app.

## License

MIT — see [LICENSE](./LICENSE).
