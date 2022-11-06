local self = CreateFrame("FRAME")
EasyFlightOptions = {}
EasyFlightOptions.needShift = false
EasyFlightOptions.landTimer = 1
EasyFlightOptions.enabled = true

self.flyTimer = 0
self.landTimer = 0
self.isFlying = false
self.isSprint = false
self.isSpacePressed = false
self.enabled = true

local function enableAddon()
	self:SetScript("OnUpdate", function(self, elapsed)
		if self.flyTimer < .5 then
			self.flyTimer = self.flyTimer + elapsed
		end
		if IsFlying() and self.isSpacePressed then
			if self.flyTimer < .5 then
				SendChatMessage(".cheat fly off", "GUILD")
				self.isFlying = false
			end
			self.isSpacePressed = false
			self.flyTimer = 0
		end
		if not IsFlying() and not IsFalling() and self.isFlying and EasyFlightOptions.landTimer ~= 0 then
			if self.landTimer > (tonumber(EasyFlightOptions.landTimer) or 1) then
				SendChatMessage(".cheat fly off", "GUILD")
				self.isFlying = false
			end
			self.landTimer = self.landTimer + elapsed
		else
			self.landTimer = 0
		end
	end)
	EasyFlightOptions.enabled = true
	self.enabled = true
end

local function disableAddon()
	self:SetScript("OnUpdate", nil)	
	EasyFlightOptions.enabled = false
	self.enabled = false
end

hooksecurefunc("JumpOrAscendStart", function()
	if not self.enabled then return end
	if IsFalling() then
		if EasyFlightOptions.needShift then
			if IsShiftKeyDown() then
				SendChatMessage(".cheat fly on", "GUILD")
				self.isFlying = true
				return
			end
		else
			SendChatMessage(".cheat fly on", "GUILD")
			self.isFlying = true
			return
		end
	end
	self.isSpacePressed = true
end)

self:RegisterEvent("ADDON_LOADED")
self:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "EasyFlight" then
		if EasyFlightOptions.enabled then
			enableAddon()
		else
			disableAddon()
		end
	end
end)

self:SetScript("OnUpdate", function(self, elapsed)
	if self.flyTimer < .5 then
		self.flyTimer = self.flyTimer + elapsed
	end
	if IsFlying() and self.isSpacePressed then
		if self.flyTimer < .5 then
			SendChatMessage(".cheat fly off", "GUILD")
			self.isFlying = false
		end
		self.isSpacePressed = false
		self.flyTimer = 0
	end
	if not IsFlying() and not IsFalling() and self.isFlying and EasyFlightOptions.landTimer ~= 0 then
		if self.landTimer > (EasyFlightOptions.landTimer or 1) then
			SendChatMessage(".cheat fly off", "GUILD")
			self.isFlying = false
		end
		self.landTimer = self.landTimer + elapsed
	else
		self.landTimer = 0
	end
end)

SLASH_EASYFLIGHT1 = '/easyflight'
function SlashCmdList.EASYFLIGHT(msg, editbox) -- 4.
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	if command == "shift" then
		EasyFlightOptions.needShift = not EasyFlightOptions.needShift
		print("Easy Flight - Shift Required to toggle flight: "..EasyFlightOptions.needShift)
	elseif command == "delay" and rest then
		EasyFlightOptions.landTimer = tonumber(rest)
		print("Easy Flight - Delay before toggling flying off: "..EasyFlightOptions.landTimer)
	else
		print("Easy Flight Settings (/easyflight ...):")
		print("   ...toggle | Toggle the Addon On/Off.")
		print("         Currently: "..tostring(EasyFlightOptions.enabled))
		print("   ...shift | Toggle if you must press shift to turn flying on from double jump.")
		print("         This is default to on to ensure compatibility with double-jump spell.")
		print("         Currently: "..tostring(EasyFlightOptions.needShift))
		print("   ...delay #seconds | How long after landing before flying is turned off.")
		print("         Set to 0 to disable turning fly off when landing.")
		print("         Currently: "..tostring(EasyFlightOptions.landTimer).." second(s)  ||  Default: 1 second")
	end
end