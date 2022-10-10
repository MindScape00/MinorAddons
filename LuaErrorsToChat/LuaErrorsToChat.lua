local frame = CreateFrame("FRAME", "FooAddonFrame");
frame:RegisterEvent("ADDON_LOADED");
local function eventHandler(self, event, arg1, ...)
	if arg1 == "LuaErrorsToChat" then
		frame:UnregisterEvent(event)
		hooksecurefunc(ScriptErrorsFrame,"DisplayMessage",function(self,msg) print(msg) end)
		print("Hooked Lua Error To Chat!")
	end
end
frame:SetScript("OnEvent", eventHandler);