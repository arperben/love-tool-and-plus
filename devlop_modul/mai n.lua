function love.load()
	arcs = {}

	for i = -4, 4 do
		local y = (i+5.5) * 60
		local angle1 = math.rad (i*90)
		for j = -4, 4 do
			local x = (j+8.5) * 120
			local angle2 = math.rad (j*90)
			local arc = {
				i = (i)*90,
				j = (j)*90, 
				x=x, y=y, 
				angle1=angle1, 
				angle2=angle1+angle2, 
				radius=25		
			}
			table.insert (arcs, arc)
		end
	end
end

function love.draw()
	for i, arc in ipairs (arcs) do
		love.graphics.setColor(1, 1, 0)
		love.graphics.arc ('line', 'open', arc.x, arc.y, arc.radius, arc.angle1, arc.angle2)
		love.graphics.setColor(1, 1, 1)
		love.graphics.line (arc.x, arc.y, 
			arc.x+arc.radius*math.cos(arc.angle1), arc.y+arc.radius*math.sin(arc.angle1)) 
		love.graphics.print ('a: '..arc.i, arc.x-70, arc.y-10)
		love.graphics.print ('d: '..arc.j, arc.x-70, arc.y+4)
	end
end