#!/bin/bash

echo "📦 Installing Discord VPS Bot..."

# Setup vars
REPO="https://github.com/YOUR_USERNAME/YOUR_REPO.git"
BOT_DIR="$HOME/discord-vps-maker-bot"

# Clone bot code
if [ ! -d "$BOT_DIR" ]; then
    git clone $REPO $BOT_DIR
else
    echo "🔄 Repo already exists, pulling updates..."
    cd $BOT_DIR && git pull
fi

cd $BOT_DIR

# Ask for token
if [ ! -f ".env" ]; then
    echo "🔐 Enter your Discord bot token:"
    read -r TOKEN
    echo "DISCORD_TOKEN=$TOKEN" > .env
fi

# Install dependencies
echo "⚙️ Installing dependencies..."
sudo apt update
sudo apt install -y python3 python3-pip docker.io wget
pip3 install -r requirements.txt

# Setup systemd service
echo "🛠️ Setting up systemd service..."
SERVICE_PATH="/etc/systemd/system/discordbot.service"

sudo bash -c "cat > $SERVICE_PATH" <<EOF
[Unit]
Description=Discord VPS Bot
After=network.target docker.service

[Service]
Type=simple
WorkingDirectory=$BOT_DIR
ExecStart=/usr/bin/python3 $BOT_DIR/bot.py
EnvironmentFile=$BOT_DIR/.env
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable discordbot
sudo systemctl restart discordbot

echo "✅ Bot installed and running 24/7 via systemd!"
