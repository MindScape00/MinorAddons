--------------- Begin to make addon and make stuff work. ---------------

-------- Login Handle --------

local colorsloginhandle = CreateFrame("frame","colorsloginhandle");
colorsloginhandle:RegisterEvent("PLAYER_LOGIN");
colorsloginhandle:SetScript("OnEvent", function()
    ColorLogin();
end);

function ColorLogin()
	if CCColor == nil then
	CCColor = "ffffff"
	end
end

-------- Defining the CMD & MSG function for later --------

local function cmd(text)
  SendChatMessage("."..text, "GUILD");
end

local function msg(text)
  SendChatMessage(""..text, "SAY");
end

----- A function that was going to be used, but replaced because it wasn't needed. -----

-- function SendColoredMessage()
	-- SendChatMessage("\124cFF".. CCColor.."\124Hitem:4665:0:0:0:0:0 :0: \124hTesting Colored Chat\124h\124r");
-- end

-------- Slash Command to control main functionality. --------

---Setting the color you want. This must be a pre-defined color or a 6-digit code, which is hopefully a hex-code.---

SLASH_CCCOLOR1, SLASH_CCCOLOR2, SLASH_CCCOLOR3 = '/color', '/cccolor', '/ccolor'; -- 3.
function SlashCmdList.CCCOLOR(msg, editbox) -- 4.
	if msg == 'purple' then 
		CCColor = "a335ee"
		print ("ConvenientColors: Color Set to |cffa335ee Purple (a335ee)")
	elseif msg == 'orange' then
		CCColor = "ff8800"
		print ("ConvenientColors: Color Set to |cffff8800 Orange (ff8800)")
	elseif msg == 'blue' then
		CCColor = "0070dd"
		print ("ConvenientColors: Color Set to |cff0070dd Blue (0070dd)")
	elseif msg == 'green' then
		CCColor = "1eff00"
		print ("ConvenientColors: Color Set to |cff1eff00 Green (1eff00)")
	elseif msg == 'red' then
		CCColor = "FF0000"
		print ("ConvenientColors: Color Set to |cffFF0000 Red (FF0000)")
	elseif msg == 'white' then
		CCColor = "ffffff"
		print ("ConvenientColors: Color Set to |cffffffff White (ffffff)")
	elseif msg == 'black' then
		CCColor = "000000"
		print ("ConvenientColors: Color Set to |cff000000 Black (000000)")
	elseif msg == 'tan' then
		CCColor = "e5cc80"
		print ("ConvenientColors: Color Set to |cffe5cc80 Tan (e5cc80)")
	elseif msg == 'grey' then
		CCColor = "9d9d9d"
		print ("ConvenientColors: Color Set to |cff9d9d9d Grey (9d9d9d)")
	elseif msg == 'pink' then
		CCColor = "FF00FF"
		print ("ConvenientColors: Color Set to |cffFF00FF Pink (FF00FF)")
	elseif msg == 'yellow' then
		CCColor = "FFFF00"
		print ("ConvenientColors: Color Set to |cffFFFF00 Yellow (FFFF00)")
	elseif msg == 'test' then -- This can be copy-pasted and continued on to add more pre-defined colors.
		CCColor = "asd876" -- This goes with the above elseif and Comment.
	elseif msg == 'Klarrisa' or msg == 'klarrisa' or msg == 'MindScape' or msg == 'Mindscape' or msg == 'mindscape' then
		print("|cffFF00FFCan you not?") --Easter Egg. Needs more Cowbell.
	elseif string.len(msg) == 6 then --Making sure it's a 6-character code if it's not a pre-defined color.
		CCColor = msg --Set the variable that controls the color you have set if it passes the length-check.
		print ("ConvenientColors: Color Set to |cff"..msg.." ("..msg..")")
	else
		print("|cffFF0000You've specified an invalid Color or HexID.") --If it fails any pre-defined variables, and it fails the 6-digit length, let's tell them they messed up, politely.
	end
end

--End Color Setting--

--Slash commands to control actually broadcasting the message-item. First is for !ann, second goes to /say.--

SLASH_CCCOLORANN1, SLASH_CCCOLORANN2, SLASH_CCCOLORANN3 = '/ann', '/cann', '/colorann'; -- 3.
function SlashCmdList.CCCOLORANN(msg, editbox) --For Sending Chat to !ann
 SendChatMessage("!ann \124cFF"..CCColor.."\124Hitem:0\124h"..msg.."\124h\124r");
end

SLASH_CCCOLORWHSP1, SLASH_CCCOLORWHSP2, SLASH_CCCOLORWHSP3 = '/cw', '/cwhisper', '/colorwhisper'; -- 3.
function SlashCmdList.CCCOLORWHSP(msg, editbox) --For Sending Colored Whispers
	if CCWhspTarg == nil or CCWhspTarg == "" then
		print("ConvenientColors | Error. No Target Specified (Define a Target with /cwt)")
	else
		SendChatMessage('!whisper "'..CCWhspTarg..'" \124cFF'..CCColor.."\124Hitem:0\124h"..msg.."\124h\124r");
	end
end

SLASH_CCWHSPTARGSET1 = '/cwt'
function SlashCmdList.CCWHSPTARGSET(msg, editbox) --For Setting Target of Color Whispers
	if msg == nil or msg == "" then
		CCWhspTarg = msg
		print("ConvenientColors | Whisper Target Cleared")
	else
		CCWhspTarg = msg
		print("ConvenientColors | Whisper Target Set to "..'"'..CCWhspTarg..'"')
	end
end
	
SLASH_CCCOLORSAY1, SLASH_CCCOLORSAY2, SLASH_CCCOLORSAY3 = '/csay', '/colored', '/test'; -- 3.
function SlashCmdList.CCCOLORSAY(msg, editbox) --Send Colors text in local chat
 SendChatMessage("\124cFF"..CCColor.."\124Hitem:0\124h"..msg.."\124h\124r");
end

SLASH_CCCOLORHELP1, SLASH_CCCOLORHELP2, SLASH_CCCOLORHELP3 = '/chelp', '/colorhelp', '/ch'; -- 3.
function SlashCmdList.CCCOLORHELP(msg, editbox) --Show help list of Commands, ect, for CC.
 print("ConvenientColors Help")
 print("  Commands")
 print("    /ann, /cann, /colorann - Sends a message to announce using your set color.")
 print("    /cw, /cwhisper, /colorwhisper - Sends a message to the set player using your set color.")
 print("    /cwt - Sets the target of your Colored Whisper (/cw).")
 print("    /csay, /colored, /test - Posts in the local chat (/say) using your set color.")
end

--[[ BACKUP OF THE ORIGINAL COMANDS
SLASH_CCCOLORANN1, SLASH_CCCOLORANN2, SLASH_CCCOLORANN3 = '/ann', '/cann', '/colorann'; -- 3.
function SlashCmdList.CCCOLORANN(msg, editbox) -- 4.
 SendChatMessage("!ann \124cFF"..CCColor.."\124Hitem:0:0:0:0:0:0 :0: \124h"..msg.."\124h\124r");
end

SLASH_CCCOLORSAY1, SLASH_CCCOLORSAY2, SLASH_CCCOLORSAY3 = '/csay', '/colored', '/test'; -- 3.
function SlashCmdList.CCCOLORSAY(msg, editbox) -- 4.
 SendChatMessage("\124cFF"..CCColor.."\124Hitem:825823:0:0:0:0:0 :0: \124h"..msg.."\124h\124r");
end
]]--

-------- End the Main-Function Commands --------

-------- Testing linking texture images in !ann. --------

-- SLASH_CCCOLORLINK1, SLASH_CCCOLORLINK2, SLASH_CCCOLORLINK3 = '/link', '/clink', '/href'; -- 3.
-- function SlashCmdList.CCCOLORLINK(msg, editbox) -- 4.
 -- SendChatMessage("!ann \124cffFFFFFF\124Hitem:4995\124h\124TInterface\\Icons\\INV_Misc_Coin_01:16\124t\124h\124r");
 -- print("!ann |cffFFFFFF|Hitem:4995|h|TInterface\\Icons\\INV_Misc_Coin_01:16|t|h|r");
-- end

-------- End Testing. Failed. --------

--------------- End All for now ---------------

