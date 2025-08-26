local function try(pcall_fn, on_error)
	local ok, result = pcall(pcall_fn)
	if not ok then
		if on_error then on_error(result) end
		return nil
	end
	return result
end

local function formatTemplate(template, data)
	local out = template
	for key, value in pairs(data) do
		out = out:gsub('{' .. key .. '}', tostring(value))
	end
	return out
end

-- Framework autodetection helpers (lightweight; adjust per your framework availability)
local function isResourceStarted(name)
	return GetResourceState(name) == 'started'
end

local function detectFramework()
	if Config.Framework ~= 'auto' then return Config.Framework end
	if isResourceStarted('vorp_core') then return 'vorp' end
	if isResourceStarted('redem_roleplay') or isResourceStarted('redemrp') then return 'redemrp' end
	return 'custom'
end

-- Job getters for known frameworks
local function getJobVorp()
	-- VORP example: exports.vorp_core:GetUser(source).getUsedCharacter.job
	local job = Config.FallbackJob
	try(function()
		local VorpCore = Proxy and Proxy.getInterface and Proxy.getInterface('vorp') or nil
		if VorpCore and VorpCore.getUser then
			local user = VorpCore.getUser(source)
			if user and user.getUsedCharacter then
				local chr = user.getUsedCharacter
				if type(chr) == 'function' then chr = chr() end
				if chr and chr.job then job = chr.job end
			end
		end
	end)
	return job
end

local function getJobRedEMRP()
	-- RedEM: exports['redem_roleplay']:getPlayerJob() varies by version; keep safe
	local job = Config.FallbackJob
	try(function()
		if exports and exports['redem_roleplay'] and exports['redem_roleplay'].getPlayerJob then
			job = exports['redem_roleplay']:getPlayerJob() or job
		elseif exports and exports['redemrp'] and exports['redemrp'].getPlayerJob then
			job = exports['redemrp']:getPlayerJob() or job
		end
	end)
	return job
end

local function getJobCustom()
	-- Implement your own job detection here if you use a different framework
	return Config.FallbackJob
end

local function getPlayerJob()
	local fw = detectFramework()
	if fw == 'vorp' then return getJobVorp() end
	if fw == 'redemrp' then return getJobRedEMRP() end
	return getJobCustom()
end

-- Get player name
local function getPlayerNameSafe()
	local name = GetPlayerName(PlayerId())
	if not name or name == '' then
		name = ('Player %s'):format(GetPlayerServerId(PlayerId()))
	end
	return name
end

-- Get current zone/city using map zones; fallback to coordinates
local function getPlayerZone()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local zoneHash = GetNameOfZone(coords.x, coords.y, coords.z)
	local zoneLabel = zoneHash and GetLabelText(zoneHash) or nil
	if zoneLabel and zoneLabel ~= 'NULL' and zoneLabel ~= '' then
		return zoneLabel
	end
	return ('(%.1f, %.1f)'):format(coords.x, coords.y)
end

-- Online players
local function getOnlineCount()
	return #GetActivePlayers()
end

-- Discord Rich Presence setup
local function setupDiscord()
	SetDiscordAppId(tonumber(Config.ClientId) or Config.ClientId)
	if Config.LargeAssetKey and Config.LargeAssetKey ~= '' then
		SetDiscordRichPresenceAsset(Config.LargeAssetKey)
		if Config.LargeAssetText and Config.LargeAssetText ~= '' then
			SetDiscordRichPresenceAssetText(Config.LargeAssetText)
		end
	end
	if Config.SmallAssetKey and Config.SmallAssetKey ~= '' then
		SetDiscordRichPresenceAssetSmall(Config.SmallAssetKey)
	end
end

local function updatePresence()
	local playerName = getPlayerNameSafe()
	local job = getPlayerJob()
	local zone = getPlayerZone()
	local online = getOnlineCount()
	local max = Config.MaxPlayers or 64
	local line = formatTemplate(Config.RichPresenceTemplate, {
		playerName = playerName,
		job = job,
		zone = zone,
		server = Config.ServerName,
		online = online,
		max = max
	})
	SetRichPresence(line)
end

CreateThread(function()
	setupDiscord()
	while true do
		updatePresence()
		Wait(Config.UpdateInterval or 15000)
	end
end)

-- Optional command for quick testing
RegisterCommand('rp_refresh', function()
	setupDiscord()
	updatePresence()
end, false)


