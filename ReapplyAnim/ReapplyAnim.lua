-------------------------------------------------------------------------------
-- Simple Chat Functions
-------------------------------------------------------------------------------

local savedReapplyAnimID = 0
local debugmode = false

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

local function msg(text)
  SendChatMessage(""..text, "SAY");
end

local function cprint(text)
	if debugmode then
		local line = strmatch(debugstack(2),":(%d+):")
		if line then
			print("|cffFFD700 REAPPLYANIM "..line..": "..text.."|r")
		else
			print("|cffFFD700 REAPPLYANIM @ERROR: "..text.."|r")
			print(debugstack(2))
		end
	end
end

local function applyAnim()
	if savedReapplyAnimID ~= 0 then
		cmd("mod anim "..savedReapplyAnimID.." self")
	end
end
-------------------------------------------------------------------------------
-- Login Handle / Start-up Initialization / Saved Variables
-------------------------------------------------------------------------------

local NewSendChatMessage = SendChatMessage; --Redefine SendChatMessage to check our own stuff before passing it to blizz api to actually send
SendChatMessage = function(msg,msgtype,lang,target)

	local omsg = msg
	local msg = gsub(msg,"|cff%x%x%x%x%x%x","");
	local msg = msg:gsub("|r","")
	if strlen(msg) == 1 then NewSendChatMessage(msg,msgtype,lang,target); return; end
	if msgtype == "WHISPER" then NewSendChatMessage(msg,msgtype,lang,target); return; end

	-- Check if typing a command at all
	if (strsub(msg,1,1) == "." or strsub(msg,1,1) == "!") then

	-- Split the command
		local cmd,sub,rest = strsplit(" ",strlower(msg),3);

	-- Check if we have both arguments from the split, nil if we don't instead of just blank string
		if sub and strlen(sub) < 1 then sub = nil; end 
		if sub then sub = ""..strtrim(sub); end
		if rest and strlen(rest) < 1 then rest = nil; end
		if rest then rest = ""..strtrim(rest); end
		cmd = ""..strsub(strtrim(cmd),2);
		print(cmd,sub,rest)

		if (cmd):find("^mo") and (sub):find("^a") and tonumber(rest) then
			savedReapplyAnimID = tonumber(rest);
			savingReapplyAnimID = true
			cprint("Saved Mod Anim: "..savedReapplyAnimID)
		end
		if msg then NewSendChatMessage(msg,msgtype,lang,target); end -- Send that message we saved earlier
	else
		NewSendChatMessage(msg,msgtype,lang,target);
		return;
	end
end

for i = 1, NUM_CHAT_WINDOWS do
    local chat = _G["ChatFrame"..i.."EditBox"]
    if chat then
		chat:HookScript("OnEnterPressed", function(self)
			C_Timer.After(3,function() applyAnim() end)
		end) 
	end
end