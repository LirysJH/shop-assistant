script_name("Shop assistant")
script_author("James Hawk")
script_version("1.0")
script_dependencies("vkeys", "samp.events")

local key = require "vkeys"
local sampev = require "lib.samp.events"
local enabled=false
local flag=false


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	sampRegisterChatCommand("sh", function(arg)
		enabled = not enabled
		if enabled then
			sampAddChatMessage(string.format("[%s]: Activated", thisScript().name), 0x40FF40)
			flag=true
		else
			sampAddChatMessage(string.format("[%s]: Deactivated", thisScript().name), 0xFF4040)
			flag=false
		end
		state, color, name = string.match(arg, "(%d+)%s+(%d+)%s+(.*)")
		return {arg}
	end)
	
	sampRegisterChatCommand("sh_r", function()
		sampAddChatMessage(string.format("[%s]: RELOADING",thisScript().name), 0x0000FF)
		thisScript():reload()
	end)
	
	while true do
		wait(0)
		
		if enabled and flag then
			if wasKeyPressed(key.VK_X) then
				sampAddChatMessage(string.format("[%s]: Deactivated", thisScript().name), 0xFF4040)
				enabled=false
				flag=false
			end
			setGameKeyState(21,255)			
			wait(100)
			if sampTextdrawIsExists(2109) and sampTextdrawIsExists(2111) then
				if sampIsDialogActive() then
					setVirtualKeyState(27)
				end
				wait(100)
				setVirtualKeyState(27)
			end
			if sampIsDialogActive(3010) then
				setVirtualKeyState(13)
				wait(50)
				if sampIsDialogActive(3021) then
					sampSendDialogResponse(3021, 1, tonumber(state), -1)
					wait(50)
					if sampIsDialogActive(3020) then
						sampSetCurrentDialogEditboxText(name)
						wait(150)
						if sampIsDialogActive(3030) then
							sampSendDialogResponse(3030, 1, tonumber(color), -1)
							wait(50)
						end
					end
				end
			end
		elseif not enabled and flag then
			setGameKeyState(21,0)
			flag=false
		end
	end
end

function setVirtualKeyState(key)
	lua_thread.create(function(key)
		setVirtualKeyDown(key, true)
		wait(150)
		setVirtualKeyDown(key, false)
	end, key)
end


function sampev.onShowDialog(id, style, title, b1, b2, text)
	lua_thread.create(function()
		if enabled then
			if id == 3040 then
				enabled=false
			end
		end
	end)
end
