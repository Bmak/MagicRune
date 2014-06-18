local composer = require("composer")
local Hero = {
	
}

local box = nil
local view = nil
local lifesTxt = nil
local maxLifes = nil
local lifes = nil
local heroType = nil

function Hero:init(type)
	heroType = type
	self.lifes = 100
	self.maxLifes = self.lifes

	self.box = display.newGroup( )

	self.box.y = 100

	self.view = display.newImage( "i/hero"..type..".png" )
	self.view.anchorX = 0
	self.view.anchorY = 0
	self.view.xScale = 0.7
	self.view.yScale = 0.7

	self.lifesTxt = display.newText( self.lifes.."/"..self.maxLifes, 0, 0, native.systemFont, 30 )
	self.lifesTxt.anchorX = 0.5	
	self.lifesTxt.anchorY = 0
	self.lifesTxt.x = self.view.contentWidth/2
	self.lifesTxt.y = -self.lifesTxt.height
	self.box:insert(self.lifesTxt)

	self.box:insert(self.view)
end

function Hero:getNumMoves()
	local moves
	if heroType == 0 then
		moves = 3
	elseif heroType == 1 then
		moves = 4
	end
	return moves
end

function Hero:getDamage(tiles)
	local damage
	if composer.heroType == 0 then
		if tiles == 2 then
			damage = 4
		elseif tiles == 3 then
			damage = 6
		end
	else
		if tiles == 2 then
			damage = 2
		elseif tiles == 3 then
			damage = 4
		elseif tiles == 4 then
			damage = 12
		end
	end

	return damage
end

function Hero:setDamage(damage)
	self:setLifes(self.lifes - damage)
end

function Hero:setLifes(lifes)
	self.lifes = lifes

	--TODO if lifes <= 0 then DIE end

	self.lifesTxt.text = self.lifes.."/"..self.maxLifes
end

function Hero:attack(target, damage)
	transition.cancel(self.view)
	
	
	local function back( ... )
		transition.to( self.view, { time=300, x=0} )

		target:setDamage(damage)
	end

	transition.to( self.view, {delay=350, time=500, x=200,transition=easing.inExpo, onComplete=back} )
end

function Hero:destroy( ... )
	transition.cancel(self.view)
	self.view:removeSelf( )
	self.view = nil
	self.box:removeSelf( )
	self.box = nil
end

return Hero