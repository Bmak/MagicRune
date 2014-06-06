local Tile = {
	
}

function Tile:new()
	local params = {
		mainBox = nil,
		view = nil,
		id = nil,
		size = 0.6,
		trState = nil,
		selMask = nil,
		selState = nil
	}
	self.__index = self
  	return setmetatable(params, self)
end

function Tile:init()

	self.selState = false

	self.mainBox = display.newGroup()
	
	self.id = math.round( 1+math.random( )*5 ) 

	self.view = display.newImage("i/tile/"..self.id..".png")
	self.view.x = self.view.width/2
	self.view.y = self.view.height/2
	self.view.xScale = self.size
	self.view.yScale = self.size

	self.selMask = display.newImage( "i/asdasd.png")
	self.selMask.x = self.view.width/2
	self.selMask.y = self.view.height/2
	self.selMask.xScale = 0.2
	self.selMask.yScale = 0.2
	self.selMask.alpha = 0
	self.mainBox:insert(self.selMask)


	local function onTouch(event)
		self:onTouch(event)
		return true
	end
	self.view:addEventListener( "touch", onTouch )

	self.mainBox:insert(self.view)

	return self
end

function Tile:onTouch(e)
	if self.trState == true then
		return true
	end

	if e.phase == "ended" then
		
		self.trState = true

		function tr_end( ... )
			self.trState = false
			self:setSelect(true)
			self.mainBox:dispatchEvent("tileSelected", { object=self })
		end
		function back( ... )
			transition.to( self.view, { xScale=self.size, yScale=self.size,transition=easing.outBack, time=300,onComplete=tr_end})
			
		end
		transition.to( self.view, { xScale=self.size*1.2, yScale=self.size*1.2, time=300,transition=easing.inOutBack,onComplete=back} )
	end
	return true
end

function Tile:setSelect(value)
	if self.selState == value then return end

	self.selState = value

	print( "SET TRANSITION" )

	local function tileRot( ... )
		self.selMask.rotation = 0
		transition.to(self.selMask, { rotation=360, time=2000,onComplete=tileRot})
	end
	if value == true then
		transition.to(self.selMask, { alpha=1, time=300,onComplete=tileRot})
	elseif value == false then
		transition.cancel(self.selMask)
		transition.to(self.selMask, { alpha=0, time=300})
	end
end

function Tile:destroy()
	self.mainBox:removeSelf()
	self.view:removeSelf( )
	self.mainBox = nil
	self.view = nil
end

return Tile