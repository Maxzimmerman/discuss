# Discuss 🗣️

**Discuss** is a real-time blog-style discussion platform built with the [Phoenix Framework](https://www.phoenixframework.org/). It allows users to create topics and post comments on them in real time using Phoenix Channels (WebSockets). GitHub OAuth is integrated for easy user authentication.

This project was created as a learning tool to explore real-time features in Phoenix and how to build interactive, dynamic applications using Elixir.

---

## ✨ Features

- 🧵 Create and browse discussion topics
- 💬 Comment in real-time on any topic using Phoenix Channels
- 🔐 GitHub OAuth authentication (via [Ueberauth](https://github.com/ueberauth/ueberauth))
- 📡 Real-time updates without page reloads
- 🧪 Clean, minimal demo for learning Phoenix with WebSockets

---

## 🛠 Tech Stack

- **Elixir** & **Phoenix Framework**
- **Phoenix Channels** for real-time communication
- **PostgreSQL** for data storage
- **Ueberauth + GitHub Strategy** for OAuth login
- **Tailwind CSS** (if applicable, or whatever styling you're using)

---

## 🚀 Getting Started

### Prerequisites

Ensure you have:

- Elixir >= 1.14
- Erlang/OTP >= 25
- Node.js >= 14
- PostgreSQL

You’ll also need to [register a GitHub OAuth app](https://github.com/settings/developers) to get your `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`.

### Setup Instructions

```bash
# Clone the repository
git clone https://github.com/yourusername/discuss.git
cd discuss

# Install dependencies
mix deps.get

# Set up the database
mix ecto.setup

# Install frontend assets
cd assets && npm install && cd ..

# Set your environment variables
export GITHUB_CLIENT_ID=yourclientid
export GITHUB_CLIENT_SECRET=yoursecret

# Run the server
mix phx.server

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
