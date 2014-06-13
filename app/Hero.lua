
local Hero = {
	
}

local box = nil
local view = nil
local lifesTxt = nil
local maxLifes = nil
local lifes = nil

function Hero:init()
	self.lifes = 100
	self.maxLifes = self.lifes

	self.box = display.newGroup( )

	self.view = display.newImage( "i/hero.png" )
	self.view.anchorX = 0
	self.view.anchorY = 0

	self.lifesTxt = display.newText( self.lifes.."/"..self.maxLifes, 0, 0, native.systemFont, 30 )
	self.lifesTxt.anchorX = 0
	self.lifesTxt.anchorY = 0
	self.box:insert(self.lifesTxt)

	self.box:insert(self.view)
end

function Hero:setDamage(damage)
	
	self:setLifes(self.lifes - damage)
end

function Hero:setLifes(lifes)
	self.lifes = lifes

	--TODO if lifes <= 0 then DIE end

	self.lifesTxt.text = self.lifes.."/"..self.maxLifes
end

function Hero:attack(target)
	
end

function Hero:destroy( ... )
	
end

return Hero