#!/bin/bash

BOT_FILE="bot.py"           # Your Python bot filename
SESSION="discordbot"        # Screen session name

echo "🔧 Updating packages and installing Python + pip..."
sudo apt update
sudo apt install python3 python3-pip screen -y

echo "📦 Installing required Python packages..."
pip3 install -r requirements.txt

# Run the bot in a screen session
if screen -list | grep -q "$SESSION"; then
    echo "🚀 Bot is already running. Reconnecting to screen..."
    screen -r $SESSION
else
    echo "🚀 Starting bot in background screen session..."
    screen -dmS $SESSION bash -c "python3 $BOT_FILE"
    echo "✅ Bot is now running in the background."
fi
