local self = CreateFrame("FRAME", "EasyFlight")

self.timer = 0
self.isFlying = false
self.isSprint = false
self.isSpacePressed = false

hooksecurefunc("JumpOrAscendStart", function()
	if IsFalling() then
		SendChatMessage(".cheat fly on", "GUILD")
		self.isFlying = true
		return
	end
	self.isSpacePressed = true
end)
self:RegisterEvent("OnUpdate")

self:SetScript("OnUpdate", function(self, elapsed)
	if self.timer < .5 then
		self.timer = self.timer + elapsed
	end
	if IsFlying() and self.isSpacePressed then
		if self.timer < .5 then
			SendChatMessage(".cheat fly off", "GUILD")
			self.isFlying = false
		end
		self.isSpacePressed = false
		self.timer = 0
	end
	--if not IsFlying() and not IsFalling() and self.isFlying then
	--	SendChatMessage(".cheat land")
	--	self.isFlying = false
	--end
end)