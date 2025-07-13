import discord
from discord import app_commands
import os
from dotenv import load_dotenv
import docker

load_dotenv()
TOKEN = os.getenv("DISCORD_TOKEN")

client = discord.Client(intents=discord.Intents.default())
tree = app_commands.CommandTree(client)
docker_client = docker.from_env()

@client.event
async def on_ready():
    await tree.sync()
    print(f"✅ Bot ready: {client.user}")

@tree.command(name="vps", description="Launch a VPS container")
@app_commands.describe(ram="RAM in GB (e.g. 1, 2, 4)")
async def vps(interaction: discord.Interaction, ram: int):
    await interaction.response.defer()
    if ram not in [1, 2, 4, 8]:
        await interaction.followup.send("❌ Invalid RAM. Choose 1, 2, 4, 8.")
        return

    container = docker_client.containers.run(
        "ubuntu:20.04",
        detach=True,
        tty=True,
        mem_limit=f"{ram}g",
        name=f"vps_{interaction.user.id}",
        command="/bin/bash"
    )

    await interaction.followup.send(f"✅ VPS Created: `{container.short_id}` with `{ram}GB` RAM")

client.run(TOKEN)
