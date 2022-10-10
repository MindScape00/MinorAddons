local MYADDON, MyAddOn = ...
local addonVersion, addonAuthor, addonName = GetAddOnMetadata(MYADDON, "Version"), GetAddOnMetadata(MYADDON, "Author"), GetAddOnMetadata(MYADDON, "Title")
local lastSpawnedNPC
-------------------------------------------------------------------------------
-- Simple Chat Functions
-------------------------------------------------------------------------------

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

local function cprint(text)
	local line = strmatch(debugstack(2),":(%d+):")
	if line then
		print("|cffFFD700"..addonName.." DEBUG "..line..": "..text.."|r")
	else
		print("|cffFFD700"..addonName.." DEBUG @ERROR: "..text.."|r")
		print(debugstack(2))
	end
end

-------------------------------------------------------------------------------
-- Login Handle / Start-up Initialization / Saved Variables
-------------------------------------------------------------------------------

local ASFNOpts
if ASFNOpts then return else ASFNOpts = {} end

local function isNotDefined(s)
	return s == nil or s == '';
end

local function InitializeSavedVars()
	if isNotDefined(ASFNOpts["enabled"]) then
		ASFNOpts["enabled"] = true
	end
end

local loginhandle = CreateFrame("frame","loginhandle");
loginhandle:RegisterEvent("ADDON_LOADED");
loginhandle:SetScript("OnEvent", function(self, event)
	InitializeSavedVars()
end);

------------------------------------------

local function ASFNChatFilter(Self,Event,Message)
	if ASFNOpts["enabled"] then
		local clearmsg = gsub(Message,"|cff%x%x%x%x%x%x","");
		local clearmsg = clearmsg:gsub("|r","");
		
		if clearmsg:find("A template has been created for editing called:") then
			local id = clearmsg:match("creature_entry:(%d*)")
			if id ~= lastSpawnedNPC then
				cmd("npc spawn "..id)
			end
			lastSpawnedNPC = id
			C_Timer.After(0.1, function()
				lastSpawnedNPC = 0
			end)
		end
	end
end
ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", ASFNChatFilter)

-----------------------------------------


SLASH_ASFNPC1, SLASH_ASFNPC2, SLASH_ASFNPC3 = '/asfn', '/asfnpc', '/autospawn'; -- 3.
function SlashCmdList.ASFNPC(msg, editbox) -- 4.
	ASFNOpts["enabled"] = not ASFNOpts["enabled"]
	cprint("Enabled: "..tostring(ASFNOpts["enabled"]))
end