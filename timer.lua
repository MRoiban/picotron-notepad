--[[pod_format="raw",created="2024-08-04 09:14:07",modified="2024-08-04 09:25:36",revision=7]]
function timer_init()
	ping = {}
	ping.len = 0
	ping.timers = {}
	ping.active = {}
end

function timer_start(t,id)
	ping.len += 1
	ping.timers[ping.len] = {0,t,id}
	ping.active[ping.len] = id
end

function timer_update()
	for k,v in pairs(ping.timers) do
		if v[1] > v[2] then
			timer_kill(v)
		end
		v[1] += 1/60
	end
end

function timer_kill(t)
	ping.len -= 1
	del(ping.active, t[3])
	del(ping.timers, t)
end