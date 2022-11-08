local _frame = CreateFrame("FRAME")
local EasyFlight = LibStub("AceAddon-3.0"):NewAddon(_frame, "EasyFlight", "AceConsole-3.0")

local AC = LibStub("AceConfig-3.0")

local function isNotDefined(s)
	return s == nil or s == '';
end

EasyFlightOptions = {}
EasyFlightOptions.needShift = false
EasyFlightOptions.tripleJump = true
EasyFlightOptions.landDelay = 2
EasyFlightOptions.enabled = true
EasyFlightOptions.jumpToLand = true

_frame.flyTimer = 0
_frame.landTimer = 0
_frame.isFlying = false
_frame.isSprint = false
_frame.isSpacePressed = false
_frame.enabled = true

local function hookFlyingOnUpdate(self, elapsed)
	if self.flyTimer < .5 then
		self.flyTimer = self.flyTimer + elapsed
	end
	if IsFlying() and self.isSpacePressed then
		if self.flyTimer < .5 then
			if EasyFlightOptions.jumpToLand == false then return end
			if EasyFlightOptions.jumpToLand == nil then
				if _frame.isDoubleJumpLanding then
					SendChatMessage(".cheat fly off", "GUILD")
					self.isFlying = false
					_frame.isDoubleJumpLanding = false
				else
					_frame.isDoubleJumpLanding = true
				end
			else
				SendChatMessage(".cheat fly off", "GUILD")
				self.isFlying = false
			end
		else
			_frame.isDoubleJumpLanding = false
		end
		self.isSpacePressed = false
		self.flyTimer = 0
	end
	if not IsFlying() and not IsFalling() and self.isFlying and EasyFlightOptions.landDelay ~= 0 then
		if self.landTimer > (tonumber(EasyFlightOptions.landDelay) or 1) then
			SendChatMessage(".cheat fly off", "GUILD")
			self.isFlying = false
		end
		self.landTimer = self.landTimer + elapsed
	else
		self.landTimer = 0
	end
end

local function enableAddon()
	_frame:SetScript("OnUpdate", hookFlyingOnUpdate)
	EasyFlightOptions.enabled = true
	_frame.enabled = true
end

local function disableAddon()
	_frame:SetScript("OnUpdate", nil)	
	EasyFlightOptions.enabled = false
	_frame.enabled = false
end

hooksecurefunc("JumpOrAscendStart", function()
	if not _frame.enabled then return end
	if IsFalling() then
		if EasyFlightOptions.needShift then
			if IsShiftKeyDown() then
				SendChatMessage(".cheat fly on", "GUILD")
				_frame.isFlying = true
				return
			end
		elseif EasyFlightOptions.tripleJump then
			if _frame.doubleJumped then
				SendChatMessage(".cheat fly on", "GUILD")
				_frame.isFlying = true
			else
				_frame.doubleJumped = true
				return;
			end
		else
			SendChatMessage(".cheat fly on", "GUILD")
			_frame.isFlying = true
			return
		end
	else
		_frame.doubleJumped = false
	end
	_frame.isSpacePressed = true
end)



local options = {
	name = "EasyFlight",
	handler = EasyFlight,
	type = "group",
	args = {
		addonToggle ={
			type = "toggle",
			name = "Enable EasyFlight",
			desc = "Toggle the Addon on/off.",
			get = "GetAddonToggle",
			set = "SetAddonToggle",
			order = 0,
			width = "full",
		},
		lineBreak1 = {
			type = "description",
			name = " ",
			fontSize = "large",
			order = 1,
			width = "full",
		},
		modifiers = {
			type = "description",
			name = "Modifiers",
			fontSize = "medium",
			order = 2,
			width = "full",
		},
		needShift = {
			type = "toggle",
			name = "Require Shift+Jump to Toggle",
			desc = "When enabled, Shift must be pressed along-side jump to toggle flight on. This allows Double Jump to work properly without toggling flight.",
			get = "GetNeedShift",
			set = "SetNeedShift",
			order = 4,
			width = "full",
		},
		tripleJump = {
			type = "toggle",
			name = "Require Triple Jump",
			desc = "When enabled, you must triple-jump to toggle flight on. This allows Double Jump to work properly without toggling flight.",
			get = "GetNeedTripleJump",
			set = "SetNeedTripleJump",
			order = 5,
			width = "full",
		},
		jumpToTurnOff = {
			type = "toggle",
			name = "Double / Triple Jump to Turn Off",
			desc = "Unchecked: No Jumping will turn off flight.\n\rChecked: Double Jump while flying to turn off flight.\n\rGrey Check: Triple Jump while flying to turn off flight.",
			get = "GetJumpToLand",
			set = "SetJumpToLand",
			order = 6,
			width = "full",
			tristate = true,
		},
		lineBreak2 = {
			type = "description",
			name = " ",
			fontSize = "large",
			order = 9,
			width = "full",
		},
		landDelay = {
			type = "range",
			min = 0,
			softMax = 5,
			max = 20,
			step = 0.1,
			bigStep = 0.5,
			name = "Landing Delay",
			desc = "How long, in seconds, after landing before toggling flight off. Set to 0 to turn off automatic flight-off when landing.",
			get = "GetLandingDelay",
			set = "SetLandingDelay",
			order = 10,
			width = 2,
		},
	},
}

function EasyFlight:GetAddonToggle(info)
	return EasyFlightOptions.enabled
end

function EasyFlight:SetAddonToggle(info, value)
	if value == true then enableAddon() else disableAddon() end
	if info[0] and info[0] ~= "" then print("Addon Enabled was set to: " .. tostring(value)) end
end

function EasyFlight:GetNeedShift(info)
	return EasyFlightOptions.needShift
end

function EasyFlight:SetNeedShift(info, value)
	EasyFlightOptions.needShift = value
	if value then EasyFlightOptions.tripleJump = not value end
	if info[0] and info[0] ~= "" then print("Shift Required was set to: " .. tostring(value)) end
end

function EasyFlight:GetNeedTripleJump(info)
	return EasyFlightOptions.tripleJump
end

function EasyFlight:SetNeedTripleJump(info, value)
	EasyFlightOptions.tripleJump = value
	if value then EasyFlightOptions.needShift = not value end
	if info[0] and info[0] ~= "" then print("Triple Jump Required was set to: " .. tostring(value)) end
end

function EasyFlight:GetJumpToLand(info)
	return EasyFlightOptions.jumpToLand
end

function EasyFlight:SetJumpToLand(info, value)
	EasyFlightOptions.jumpToLand = value
	local valueReadable
	if value == true then valueReadable = "Double Jump" elseif value == nil then valueReadable = "Triple Jump" elseif value == false then valueReadable = "Off" end
	if info[0] and info[0] ~= "" then print("Jump To Land was set to: " .. tostring(value)) end
end

function EasyFlight:GetLandingDelay(info)
	return tonumber(EasyFlightOptions.landDelay)
end

function EasyFlight:SetLandingDelay(info, value)
	EasyFlightOptions.landDelay = tonumber(value)
	if info[0] and info[0] ~= "" then print("Landing Delay was set to: " .. tostring(value)) end
end

function EasyFlight:OnInitialize()
	if EasyFlightOptions.enabled then
		enableAddon()
	else
		disableAddon()
	end
	AC:RegisterOptionsTable("EasyFlight", options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("EasyFlight", "EasyFlight")
	
	if isNotDefined(EasyFlightOptions.enabled) then EasyFlightOptions.enabled = true end
	if isNotDefined(EasyFlightOptions.landDelay) then EasyFlightOptions.landDelay = 2 end
	if isNotDefined(EasyFlightOptions.needShift) then EasyFlightOptions.needShift = false end
	if isNotDefined(EasyFlightOptions.tripleJump) then EasyFlightOptions.tripleJump = true end
	if isNotDefined(EasyFlightOptions.jumpToLand) then EasyFlightOptions.jumpToLand = true end
end

SLASH_EASYFLIGHT1 = '/easyflight'
function SlashCmdList.EASYFLIGHT(msg, editbox) -- 4.
	local command, rest = msg:match("^(%S*)%s*(.-)$")
	if command == "shift" then
		EasyFlightOptions.needShift = not EasyFlightOptions.needShift
		print("Easy Flight - Shift Required to toggle flight: "..EasyFlightOptions.needShift)
	elseif command == "delay" and rest then
		EasyFlightOptions.landDelay = tonumber(rest)
		print("Easy Flight - Delay before toggling flying off: "..EasyFlightOptions.landDelay)
	elseif command == "settings" then
		print("Easy Flight Settings (/easyflight ...):")
		print("   ...toggle | Toggle the Addon On/Off.")
		print("         Currently: "..tostring(EasyFlightOptions.enabled))
		print("   ...shift | Toggle if you must press shift to turn flying on from double jump.")
		print("         This is default to on to ensure compatibility with double-jump spell.")
		print("         Currently: "..tostring(EasyFlightOptions.needShift))
		print("   ...delay #seconds | How long after landing before flying is turned off.")
		print("         Set to 0 to disable turning fly off when landing.")
		print("         Currently: "..tostring(EasyFlightOptions.landTimer).." second(s)  ||  Default: 1 second")
	else
		InterfaceOptionsFrame_OpenToCategory(_frame.optionsFrame)
		InterfaceOptionsFrame_OpenToCategory(_frame.optionsFrame)
	end
end