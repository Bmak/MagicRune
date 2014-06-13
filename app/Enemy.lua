
local Enemy = {
	
}

local box = nil
local view = nil
local lifesTxt = nil
local maxLifes = nil
local lifes = nil

function Enemy:init()
	self.lifes = 50
	self.maxLifes = self.lifes

	self.box = display.newGroup( )

	self.view = display.newImage( "i/monstr.png" )
	self.view.xScale = 0.7
	self.view.yScale = 0.7
	self.view.y = 50
	self.view.anchorX = 0
	self.view.anchorY = 0

	self.lifesTxt = display.newText( self.lifes.."/"..self.maxLifes, 0, 0, native.systemFont, 30 )
	self.lifesTxt.x = self.view.contentWidth - self.lifesTxt.width
	self.lifesTxt.anchorX = 0
	self.lifesTxt.anchorY = 0
	self.box:insert(self.lifesTxt)

	self.box:insert(self.view)
end

function Enemy:setDamage(damage)
	
	self:setLifes(self.lifes - damage)
end

function Enemy:setLifes(lifes)
	self.lifes = lifes

	--TODO if lifes <= 0 then DIE end

	self.lifesTxt.text = self.lifes.."/"..self.maxLifes
end

function Enemy:attack(target)
	
end

function Enemy:destroy( ... )
	
end

return Enemy