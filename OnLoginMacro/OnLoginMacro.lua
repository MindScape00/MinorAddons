local MYADDON, MyAddOn = ...
local addonVersion, addonAuthor, addonName = GetAddOnMetadata(MYADDON, "Version"), GetAddOnMetadata(MYADDON, "Author"), GetAddOnMetadata(MYADDON, "Title")

local OnLoginMacros = {}
local loadingPoints = 0
local runOnce = false

local function GetAllMacros()
	for i=121,138 do
		name, icon, body, isLocal = GetMacroInfo(i)
		if name and name == "OnLogin" then
			useCharacter = true
			table.insert(OnLoginMacros,body)
--			print("Added "..body.." to OnLoginMacros")
		end
	end
	if useCharacter ~= true then
		for i=1,120 do
			name, icon, body, isLocal = GetMacroInfo(i)
			if name and name == "OnLogin" then
				table.insert(OnLoginMacros,body)
			end
		end
	end
end

local dummy = function() end
local function runMacros()
	for i,body in ipairs(OnLoginMacros) do
		local coms = { strsplit(string.char(10), body) }
		for k,v in ipairs(coms) do 
			MacroEditBox:SetText(v)
			local ran = xpcall(ChatEdit_SendText, dummy, MacroEditBox)
			if not ran then
				print("|cff33ff99OnLoginMacro:|r", "This command failed:", v)
			end
		end
	end
end

local function processLogin()
	if loadingPoints == 2 and runOnce == false then
--		print("OnLoginMacro : Processing Macros")
		GetAllMacros();
		runMacros();
		runOnce = true
	end
end

local loginhandle = CreateFrame("frame","loginhandle");
loginhandle:RegisterEvent("ADDON_LOADED");
loginhandle:RegisterEvent("VARIABLES_LOADED");
loginhandle:SetScript("OnEvent", function(self, event, name)
	if (event == "ADDON_LOADED" and name == addonName) then
		loadingPoints = loadingPoints+1
--		print("OnLoginMacro : Addon Loaded")
		if loadingPoints == 2 and runOnce == false then
			C_Timer.After(3,processLogin)
		end
		loginhandle:UnregisterEvent("ADDON_LOADED");
	elseif (event == "VARIABLES_LOADED") then
		loadingPoints = loadingPoints+1
--		print("OnLoginMacro : Variables Loaded")
		if loadingPoints == 2 and runOnce == false then
			C_Timer.After(3,processLogin)
		end
		loginhandle:UnregisterEvent("VARIABLES_LOADED");
	end
end);