
-------------------------------------------------------------------------------
-- Read your chat, switch !gps around if you are doing it wrong (Auto convert ".gps x dir" to ".gps dir x")
-------------------------------------------------------------------------------

local debug = false

local function cprint(text)
	if debug then
		local line = strmatch(debugstack(2),":(%d+):")
		if line then
			print("|cffFFD700 CommandSwitchDebug "..line..": "..text.."|r")
		else
			print("|cffFFD700 CommandSwitchDebug @ERROR: "..text.."|r")
			print(debugstack(2))
		end
	end
end

NewSendChatMessage = SendChatMessage; --Redefine SendChatMessage to check our own stuff before passing it to blizz api to actually send
SendChatMessage = function(msg,msgtype,lang,target)

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

	-- Check if command is gps, and both arguments exist backwards	
		if (cmd):find("gps") and tonumber(sub) and rest then -- If they do, lets make sure they gave a proper direction
			if (strlower(strsub(rest,1,1)) == "f") or (strlower(strsub(rest,1,1)) == "b") or (strlower(strsub(rest,1,1)) == "l") or (strlower(strsub(rest,1,1)) == "r") or (strlower(strsub(rest,1,1)) == "u") or (strlower(strsub(rest,1,1)) == "d") then -- Then reverse their arguments dir<->dist and keep it as the new message for later
				msg = strjoin(" ","."..strlower(cmd),strlower(rest),tonumber(sub))	
				cprint("Reversed .gps direction and distance.")
			end
	-- Check if the command is go[object] instead, and arguments were given.
		elseif (cmd):find("go") and sub and rest then
			if (strlower(strsub(sub,1,1)) == "m") or (strlower(strsub(sub,1,1)) == "c") then
				rest1,rest2 = strsplit(" ",strlower(rest),3); -- Split the direction and value apart
				if tonumber(rest1) and tonumber(rest1) < 10000 and rest2 then -- check if the first argument was the number, and not a GUID, and a direction exists
					msg = strjoin(" ","."..strlower(cmd),strlower(sub),strlower(rest2),tonumber(rest1)) -- Reverse the distance and direction in the message to send later
					cprint("Reversed .gobject (move/copy) direction and distance.")
				else
					NewSendChatMessage(msg,msgtype,lang,target) -- If it failed because number was GUID, or there was no direction given
					cprint("No Command Modification Done: Number was GUID or no direction given.")
					return;
				end
			elseif (strlower(strsub(sub,1,1)) == "l") then
				msg = strjoin(" ",".look object "..rest)
				cprint("Transferred .gobject look -> .look object")
			else
				NewSendChatMessage(msg,msgtype,lang,target) -- If it failed because number was GUID, or there was no direction given
				cprint("No Command Modification Done: .gobject other than Move, Copy, or Look.")
				return;
			end
		else -- If they gave them in correct order or something else, just send it as normal and hope it works or they'll just get an error
			NewSendChatMessage(msg,msgtype,lang,target);
			cprint("No Command Modification Done: Command had correct syntax already, or not a supported command.")
			return;
		end
	end
	if msg then NewSendChatMessage(msg,msgtype,lang,target); end -- Send that message we saved earlier
end


--Debug /slash Command
SLASH_CCSwitchDebug1, SLASH_CCSwitchDebug2 = '/commandswitchdebug', '/csdebug'; -- 3.
function SlashCmdList.CCSwitchDebug(msg, editbox) -- 4.
	if debug then
		debug = not debug
	else
		debug = true
	end
	print("Debug set to "..tostring(debug))
end