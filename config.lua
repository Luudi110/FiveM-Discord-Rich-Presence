Config = {}

-- Discord Application (Client) ID from https://discord.com/developers/applications
Config.ClientId = 'app_id' -- change to your real client id (string)

-- Rich Presence image keys uploaded in the Discord application "Rich Presence > Art Assets"
Config.LargeAssetKey = 'large_image_key' -- e.g. 'redm_logo'
Config.LargeAssetText = 'RedM Roleplay'  -- tooltip when hovering the large asset

Config.SmallAssetKey = 'small_image_key' -- e.g. 'sheriff'
Config.SmallAssetText = 'On Duty'        -- tooltip for the small asset

-- Update frequency in milliseconds
Config.UpdateInterval = 15000 -- 15 seconds

-- Server info
Config.ServerName = 'My RedM Server'
Config.MaxPlayers = 64 -- change to your slot count

-- Text template for the Rich Presence main line (shows under the app name)
-- Available placeholders: {playerName}, {job}, {zone}, {server}, {online}, {max}
Config.RichPresenceTemplate = '{playerName} | {job} | {zone} | {online}/{max} on {server}'

-- Job/faction extraction options
-- If you have a framework, set the Framework to 'vorp', 'redemrp', or 'custom'.
-- For 'custom', implement getPlayerJob() in client.lua where indicated.
Config.Framework = 'auto' -- 'auto' | 'vorp' | 'redemrp' | 'custom'

-- Optional: Static fallback job/faction if framework not detected
Config.FallbackJob = 'Civilian'


