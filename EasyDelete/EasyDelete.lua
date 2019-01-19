BINDING_HEADER_EASYDELETEHEADER = "EasyDelete"
BINDING_NAME_EASYDELETEKEY = "Delete Key (Set with /edkey)"

currentVersion = GetAddOnMetadata("EasyDelete", "Version")
eddebug = 0

local easydeletelogin = CreateFrame("frame","easydeletelogin");
easydeletelogin:RegisterEvent("PLAYER_LOGIN");
easydeletelogin:SetScript("OnEvent", function()
	if sendChatMessage == nil then
		sendChatMessage = 1
	end
	if deleteKey == nil then
		deleteKey = "DELETE"
	end
	oldCommand = GetBindingByKey(deleteKey)
	if eddebug == 1 then
		print(oldCommand)
	end
end);

function BindDelKeyV2()
	if CursorHasItem() then
		heldtype, itemID = GetCursorInfo()
		SetBinding(deleteKey, "EASYDELETEKEY")
		if eddebug == 1 then
			print("Holding Item: "..itemID..", Setting Delete Binding")
		end
	else
		SetBinding(deleteKey, oldCommand)
		if eddebug == 1 then
			print("Not Holding Item, Reverting Binding of "..deleteKey.." to "..oldCommand)
		end
	end
end

function EasyDelItem()
	heldtype, itemID = GetCursorInfo()
	if heldtype == "item" then
		DeleteCursorItem()
		name,link = GetItemInfo(itemID)
		if sendChatMessage == 1 then
			print("Deleted Item: "..link)
		end
	end
end

local easydeletesometimes = CreateFrame("frame","easydeletesometimes");
easydeletesometimes:RegisterEvent("CURSOR_UPDATE");
easydeletesometimes:SetScript("OnEvent", function()
	BindDelKeyV2();
end);

SLASH_CCEDKEY1 = '/edkey';
function SlashCmdList.CCEDKEY(msg, editbox)
	if msg == nil or msg == "" or msg == "default" then
		deleteKey = "DELETE"
		print("EasyDelete | Key Set to Default (DELETE).")
	else
		deleteKey = msg
		print("EasyDelete | Key Set to "..deleteKey..".")
		oldCommand = GetBindingByKey(deleteKey)
	end
end

SLASH_CCEDHELP1,SLASH_CCEDHELP2 = '/easydelete', '/ed';
function SlashCmdList.CCEDHELP(msg, editbox)
	print("ConvenientCommands: EasyDelete version "..currentVersion);
	print("  '/edkey' to set a key. (Must Follow WoW API Key Format)")
	print("  '/edmessage' (/edm) to Toggle Delete Message")
end

SLASH_CCEDMESSAGETOGGLE1,SLASH_CCEDMESSAGETOGGLE2 = '/edmessage', '/edm';
function SlashCmdList.CCEDMESSAGETOGGLE(msg, editbox)
	if sendChatMessage == 1 then
		sendChatMessage = 0
		print("EasyDelete | Chat Message Disabled.")
	else
		sendChatMessage = 1
		print("EasyDelete | Chat Message Enabled.")
	end
end