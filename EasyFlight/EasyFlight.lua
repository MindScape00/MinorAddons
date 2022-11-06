local self = CreateFrame("FRAME")

self.flyTimer = 0
self.landTimer = 0
self.isFlying = false
self.isSprint = false
self.isSpacePressed = false

hooksecurefunc("JumpOrAscendStart", function()
	if IsFalling() and IsShiftKeyDown() then
		SendChatMessage(".cheat fly on", "GUILD")
		self.isFlying = true
		return
	end
	self.isSpacePressed = true
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
	if not IsFlying() and not IsFalling() and self.isFlying then
		if self.landTimer > 1 then
			SendChatMessage(".cheat fly off", "GUILD")
			self.isFlying = false
		end
		self.landTimer = self.landTimer + elapsed
	else
		self.landTimer = 0
	end
end)