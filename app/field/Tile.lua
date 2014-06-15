local composer = require( "composer" )

local Tile = {
	
}

function Tile:new()
	local params = {
		mainBox = nil,
		view = nil,
		id = nil,
		size = 0.5,
		trState = nil,
		selMask = nil,
		selState = nil,
		ind = nil,
		column = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end

function Tile:init(index, column)
	self.ind = index
	self.column = column

	self.selState = false

	self.mainBox = display.newGroup()
	
	self.id = math.round( 1+math.random( )*5 ) 

	self.selMask = display.newImage( "i/asdasd.png")
	self.selMask.xScale = 0.2
	self.selMask.yScale = 0.2
	self.selMask.x = self.selMask.contentWidth/2
	self.selMask.y = self.selMask.contentHeight/2
	self.selMask.alpha = 0
	self.mainBox:insert(self.selMask)

	self.view = display.newImage("i/tile/"..self.id..".png")
	self.view.xScale = self.size
	self.view.yScale = self.size
	self.view.x = self.selMask.contentWidth/2
	self.view.y = self.selMask.contentHeight/2
	self.mainBox:insert(self.view)
	

	local function onTouch(event)
		self:onTouch(event)
		return true
	end
	self.view:addEventListener( "touch", onTouch )

	return self
end

function Tile:onTouch(e)

	if e.phase == "ended" or e.phase == "cancelled" then
		local endSelect = { name="endSelect", target=self }
		self.mainBox:dispatchEvent(endSelect)
	end


	if self.trState == true then
		return true
	end

	if self.selState == true then
		-- return true
	end


	if e.phase == "moved" or e.phase == "began" then
		
		-- self.trState = true

		function tr_end( ... )
			-- self.trState = false
			-- self:setSelect(true)
			-- print("SET SELECT")
		end
		function back( ... )
			-- transition.to( self.view, { xScale=self.size, yScale=self.size,transition=easing.outBack, time=50,onComplete=tr_end})
		end
		-- transition.to( self.view, { xScale=self.size*1.2, yScale=self.size*1.2, time=50,transition=easing.inOutBack,onComplete=back} )
		
		-- print("SET TOUCH")


		local selectedEvent = { name="tileSelected", target=self }
		self.mainBox:dispatchEvent(selectedEvent)
	end
	return true
end

function Tile:setSelect(value)
	-- if self.selState == value then return end

	self.selState = value

	local function tileRot( ... )
		self.selMask.rotation = 0
		transition.to(self.selMask, { rotation=360, time=2000,onComplete=tileRot})
		-- print("MASK "..self.selMask.alpha)
	end
	if value == true then
		transition.to(self.selMask, { alpha=1, time=200,onComplete=tileRot})
	elseif value == false then
		transition.cancel(self.selMask)
		transition.to(self.selMask, { alpha=0, time=200})
	end
end

function Tile:getToHero(d,attacker, mode)
	transition.cancel(self.selMask)
	self.selMask.alpha = 0
	local dx, dy = self.mainBox:localToContent( 0, 0 )
	self.mainBox.x = dx
	self.mainBox.y = dy
	local appView = composer.getScene(mode).view
	appView:insert(self.mainBox)

	local function remove()
		self:clearData()
	end
	local function nextStep()
		transition.to(self.view, { time=100, xScale=0.1,yScale=0.1,transition=easing.aseInOutBounce, onComplete=remove })
	end

	dx = attacker.box.x + attacker.box.width/2 - 100
	dy = attacker.box.y + attacker.box.height/2
	transition.to(self.mainBox, { delay=d*30, time=300, x=dx,y=dy,transition=easing.aseInOutBounce, onComplete=nextStep })


end

function Tile:destroy()
	self:getToHero()
end

function Tile:clearData( ... )
	self.mainBox:removeSelf()
	self.view:removeSelf( )
	transition.cancel(self.selMask)
	self.selMask:removeSelf( )
	self.mainBox = nil
	self.view = nil
	self.selMask = nil
end

return Tile