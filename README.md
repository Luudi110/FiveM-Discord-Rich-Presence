## RedM Discord Rich Presence (Lua)

A lightweight, configurable Discord Rich Presence resource for RedM written in pure Lua. It shows the player name, job/faction, zone/city, server name, and online players, and updates automatically using built-in natives.

### Features
- **Pure Lua**: No Node.js – only natives and client-side Lua.
- **Configurable**: Client ID, images (large/small), texts, and interval via `config.lua`.
- **Player info**: Name, job/faction, zone/city, online/slots, and server name.
- **Framework auto-detection**: Supports VORP and RedEM:RP (works without a framework too).
- **Safe fallback**: If a job cannot be read, `Config.FallbackJob` is used.

### Requirements
- RedM (rdr3) server.
- A Discord Application (Client) ID and uploaded Rich Presence assets in the Discord Developer Portal.

### Installation
1. Place the folder in `resources/redm_discord_rp` (any name is fine).
2. Add to your `server.cfg`:
```ini
ensure redm_discord_rp
```
3. Start the server.

### Set up Discord Application and Assets
1. Go to Discord Developer Portal → Applications → New Application.
2. Copy your **Application ID** (Client ID) and set `Config.ClientId` in `config.lua`.
3. Under Rich Presence → Art Assets, upload your images.
   - Large image: set the name in `Config.LargeAssetKey`
   - Small image: set the name in `Config.SmallAssetKey`
4. Save changes.

### Configuration
Open `config.lua` and update these fields:
```lua
Config.ClientId = 'app_id'             -- your Discord Application ID
Config.LargeAssetKey = 'large_image_key'
Config.LargeAssetText = 'RedM Roleplay'
Config.SmallAssetKey = 'small_image_key'
Config.SmallAssetText = 'On Duty'
Config.UpdateInterval = 15000           -- ms between updates
Config.ServerName = 'My RedM Server'
Config.MaxPlayers = 64
Config.RichPresenceTemplate = '{playerName} | {job} | {zone} | {online}/{max} on {server}'
Config.Framework = 'auto'               -- 'auto' | 'vorp' | 'redemrp' | 'custom'
Config.FallbackJob = 'Civilian'
```

Available placeholders in `Config.RichPresenceTemplate`:
- `{playerName}`: player name
- `{job}`: job/faction
- `{zone}`: current city/area
- `{server}`: server name
- `{online}`: number of online players
- `{max}`: max slots

### Framework integration
- **Auto**: tries `vorp_core` and `redem_roleplay`/`redemrp` automatically.
- **VORP**: attempts to read job via VORP API (fails gracefully).
- **RedEM:RP**: tries to read job via `redem_roleplay`/`redemrp` exports.
- **Custom**: set `Config.Framework = 'custom'` and implement your logic in `getJobCustom()` in `client.lua`.

### Natives used
- `SetDiscordAppId`
- `SetDiscordRichPresenceAsset`
- `SetDiscordRichPresenceAssetText`
- `SetDiscordRichPresenceAssetSmall`
- `SetRichPresence`

### Commands
- `/rp_refresh`: Manually refresh Rich Presence (client-side).

### Troubleshooting
- **Nothing shows in Discord**: Ensure the Discord client is running, and your Application ID and asset keys exactly match those created in the Developer Portal.
- **Images do not display**: Confirm images are uploaded, approved, and that you are using their exact names as keys.
- **Job is always 'Civilian'**: Your framework may not be detected. Set `Config.Framework` to the correct value, or fill in `getJobCustom()`.
- **Zone shows coordinates**: Not all zones have labels. This is a controlled fallback. You can extend zone logic in `client.lua`.

### Performance
The default update interval is 15 seconds. Avoid setting the interval too low to prevent unnecessary updates.

### File structure
```text
fxmanifest.lua
config.lua
client.lua
```

### License
MIT – free to use and adapt. Attribution is appreciated but not required.

### Credits
Built for RedM (rdr3). Natives and Rich Presence provided by Cfx.re and Discord.
