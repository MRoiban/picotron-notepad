--[[pod_format="raw",created="2024-08-04 13:35:00",modified="2024-08-04 19:46:04",revision=173]]
include "timer.lua"
include "button.lua"

function _init()
	ww=120
 	wh=120
 	window({width = ww, height = wh, title = "NOTEPAD" })
 	g = create_gui()
 	timer_init()
 	menuitem {id="save", label="Save Notes", action=function()save_text()end}
 	menuitem {id="load", label="Load Notes", action=function()load_text()end}
--	crs = {}
--	crs.x = 8 + 1
--	crs.y = 11
--	crs.h = 6

	-- Pagination System
	text = {{}}
	page_editor = {}
	button_next = button_construct("",7,103,8,8,_,_)
	button_previous = button_construct("",1,108,6,6,_,_)
	pagination = 1
	-- each page has it's own text_area	
	page_editor[pagination] = g:attach_text_editor({
			x = 0, y = 0,
			width = 0, height = 0
	})

	load_text()
end

function cursor_allowed(lvl)
	return #name - ( 22 * ( lvl - 1))
end

function _update()
   page_editor[pagination]:set_keyboard_focus(true)
	g:update_all()
	timer_update()
	
	text[pagination] = page_editor[pagination]:get_text()
	
--	if btn(0) and crs.cx < #name then 
--		crs.x -= 4 
--	end
--	if btn(1) then crs.x += 4 end

	-- Pagination System
	toggle_button(button_next)
	toggle_button(button_previous)
	
	if button_next.state == 1 then
		pagination += 1
		if #page_editor < pagination then
		page_editor[pagination] = g:attach_text_editor({
			x = 0, y = 0,
			width = 0, height = 0
		})
		end
		button_next.state = 0
		add(text,{})
	end
	
	if button_previous.state == 1 and pagination > 1 then
		pagination -= 1
		button_previous.state = 0
	end
	autosave()
end

function autosave()
	if not(in_table(ping.active, 3)) then
		timer_start(2,3)
		save_text()
	end
end

function in_table(t, a)
  for i = 1, #t do
    if t[i] == a then
      return true
    end
  end
  return false
end

function _draw()
	cls(7)
	print(" ")
	-- Display the page text
	for i=1,#text[pagination] do
		print(text[pagination][i],5,_,0)
	end
--	circfill(7,107,2,2)
--	circfill(3,111,2,9)
	print(pagination, 56,100,5)
	line(0,118,120,118,5)
	line(0,116,120,116,5)

	
	if button_next.hovered == true then
		line(10+4,114,10+4,104-4,5) -- | 
		line(0,104-4,10+4,114,5)  -- \
		line(0,104-4,10+4,104-4,5)  -- -
		line(10+4,114,120,114,5) 
	else
		line(10,114,10,104,5)
		line(0,104,10,114,5)
		line(0,104,10,104,5)
		line(10,114,120,114,5) 

	end
	
--	if not(in_table(ping.active, 0)) then
--		if not(in_table(ping.active, 1)) then
--			timer_start(0.6,0)
--			timer_start(1.2,1)
--		end
--	else
--		line(crs.x,crs.y,crs.x,crs.y + crs.h,5)
--	end
end

function save_text()
	store("/appdata/notepad_text.pod", text)
end

-- Load text content from a file
function load_text()
	local saved_text = fetch("/appdata/notepad_text.pod")
	if saved_text then
		text = saved_text
		-- Initialize editors for loaded pages
		for i = 1, #text do
			page_editor[i] = g:attach_text_editor({
				x = 0, y = 0,
				width = 0, height = 0
			})
			page_editor[i]:set_text(text[i])
		end
		pagination = 1
	end
end
