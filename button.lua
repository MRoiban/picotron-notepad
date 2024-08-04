--[[pod_format="raw",created="2024-08-04 17:40:00",modified="2024-08-04 18:17:37",revision=3]]
include "timer.lua"

function toggle_button(b)
	flag = mouse_in_button_area(b)
	b.hovered = flag
	if flag == true and not(in_table(ping.active, b.id)) then
		if mb == 1 and b.state == 0 then
			timer_start(0.15,b.id)
			b.text = "true"
			b.state = 1
		elseif mb == 1 and b.state == 1 then
			timer_start(0.15,b.id)
			b.text = "false"
			b.state = 0
		end
	end
end


function hold_button(b)
	flag = mouse_in_button_area(b)
	b.hovered = flag
	if flag == true then
		if mb == 1 then
			b.text = "true"
			b.state = 1
		else
			b.text = "false"
			b.state = 0
		end
	else
		b.text = "false"
		b.state = 0
	end
end

function mouse_in_button_area(b)
	mx,my,mb = mouse()
	if mx > b.x then
		if mx < b.xw then
			if my > b.y then
				if my < b.yh then
					return true
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end	
	else
		return false
	end
end

function button_draw(b)
	rectfill(b.x, b.y, b.xw, b.yh,b.color)
	rect(b.x, b.y, b.xw, b.yh,b.border.color)
	print(b.text,b.x+2,b.y+2,10)
end

function button_construct(txt,x,y,w,h,c,bc)
	local b = {}
	b.w=w
	b.h=h
	b.x = x
	b.y = y
	b.xw = b.x + b.w
	b.xh = b.x + b.h
	b.yw = b.y + b.w
	b.yh = b.y + b.h
	b.color = c
	b.border = {}
	b.border.color = bc
	b.text = txt
	b.state = 0
	b.id = rnd(10000)
	b.hovered = 0
	return b
end