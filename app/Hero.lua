
local Hero = {
	
}

local box = nil
local view = nil

function Hero:init()
	self.box = display.newGroup( )

	self.view = display.newImage( "i/hero.png" )
	self.view.anchorX = 0
	self.view.anchorY = 0

	self.box:insert(self.view)
end

return Hero