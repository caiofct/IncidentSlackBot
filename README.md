# Incident Slack Bot

This project is an Incident Management Bot for Slack. It allows users to create and manage incidents directly from Slack and also provides a nice web UI to view all created incidents.

## Prerequisites

- Ruby version: 3.4.1
- Rails version: 8.0.1
- PostgreSQL: 17
- TailwindCSS v4

## Rails app setup

### 1. Clone the repository

```sh
git clone https://github.com/yourusername/IncidentSlackBot.git
cd IncidentSlackBot
```

### 2. Setup environment variables

Copy the `.env.sample` file in the root directory to a `.env` and fill in the environment variables.

### 3. Create a rails master key

Create a `config/master.key` with the correct secret.

### 4. Run the database using docker compose

```sh
docker-compose up
```

### 5. Install gems and setup the database

```sh
bundle install
./bin/rails db:prepare
```

### 6. Start the tailwind and rails server

```sh
./bin/dev
```

## Slack App Setup

### 1. Create a Slack App

- Go to the Slack API and create a new app.
- Choose "From scratch" and give your app a name and select the workspace where you want to install the app.

### 2. Configure OAuth & Permissions

- Go to "OAuth & Permissions" in the left sidebar
- Add the following OAuth scopes:
  - channels:join
  - channels:manage
  - chat:write
  - commands
  - groups:write
  - users:read
- Click "Save Changes"

3. Install the App to your Workspace

- Go to "Install App" in the left sidebar
- Click "Install App to Workspace"
- Authorize the app

4. Configure Commands

- Go to Commands in the left sidebar
- Create new command
- Fill in the request url with: `https://<your-domain.com>/slack/commands
- Fill the remaining fields
- Click "Save"

5. Configure Interactivity & Shortcuts

- Go to "Interactivity & Shortcuts" in the left sidebar
- Enable "Interactivity"
- Set the "Request URL" to https://<your-domain.com>/slack/interactions
- Click "Save Changes"

7. Retrieve Slack Credentials

- Go to "OAuth & Permissions" in the left sidebar
- Copy the "Bot User OAuth Token" and add it to your rails credentials with `rails credentials:edit`
- Go to "Basic Information" in the left sidebar
- Copy the "Signing Secret" and add it to your rails credentials with `rails credentials:edit`

8. Test the app locally with ngrok

- Run `ngrok http --url=<your-domain.com> 3000`
- Test the app locally by invoking the slash command in your slack workspace

## Notes

I've created a `RootlyInteractionsJob` class to handle the interactions request from slack in a Solid Queue job and
prevent it from giving a timeout in case the request takes more than 3s. However, since I'm using a render free plan
and it does not support having a worker service I ended up commenting out the job enqueing and just using a synchronous request on `SlackController#interactions`. It seems to be working well so far in the production environment.
