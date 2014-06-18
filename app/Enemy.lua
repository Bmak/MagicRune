local composer = require("composer")


local Enemy = {
	
}

local box = nil
local view = nil
local lifesTxt = nil
local maxLifes = nil
local lifes = nil

local state = nil

function Enemy:init(type)
	self.box = display.newGroup( )
	self.box.y = 100
	self.state = "alive"

	local pic = nil
	if type <= 2 then
		pic = "i/monstr"..type..".png"
		self.lifes = 15
		self.maxLifes = self.lifes
	elseif type == 99 then
		if composer.heroType == 0 then
			pic = "i/hero1.png"
		else
			pic = "i/hero0.png"
		end
		self.lifes = 100
		self.maxLifes = self.lifes
	else
		pic = "i/boss.png"
		self.lifes = 30
		self.maxLifes = self.lifes
	end

	self.view = display.newImage( pic )
	self.view.anchorX = 0.5
	self.view.anchorY = 0.5
	if type ~= 99 then
		self.view.xScale = 0.5
		self.view.yScale = 0.5
	else
		self.view.xScale = 0.7
		self.view.yScale = 0.7
	end
	self.view.x = self.view.contentWidth/2
	self.view.y = self.view.contentHeight/2
	

	self.lifesTxt = display.newText( self.lifes.."/"..self.maxLifes, 0, 0, native.systemFont, 30 )
	self.lifesTxt.x = self.view.contentWidth - self.lifesTxt.width
	self.lifesTxt.anchorX = 0.5
	self.lifesTxt.anchorY = 0
	self.lifesTxt.x = self.view.contentWidth/2
	self.lifesTxt.y = -self.lifesTxt.height
	self.box:insert(self.lifesTxt)

	self.box:insert(self.view)
	-- transition.to(self.view, { time=500, x=self.view.contentWidth/2,transition=easing.aseInOutBounce})
	
end

function Enemy:getDamage(tiles)
	local damage
	if tiles == 2 then
		damage = 2
	elseif tiles == 3 then
		damage = 3
	elseif tiles == 4 then
		damage = 5
	elseif tiles == 5 then
		damage = 8
	end
	return damage
end

function Enemy:setDamage(damage)
	self:setLifes(self.lifes - damage)
end

function Enemy:showDie()
	local function kill( ... )
		local killEvent = { name="killEvent", target=self }
		self.box:dispatchEvent( killEvent)
	end

	transition.to(self.view, { time=700, yScale=0.1,onComplete=kill})
end

function Enemy:setLifes(lifes)
	self.lifes = lifes

	if self.lifes <= 0 then
		self.lifes = 0
		self.state = "killed"
		self:showDie()
	end

	self.lifesTxt.text = self.lifes.."/"..self.maxLifes
end

function Enemy:attack(target, damage)
	transition.cancel(self.view)
	
	local function back( ... )
		transition.to( self.view, { time=300, x=self.view.contentWidth/2} )

		target:setDamage(damage)
	end

	transition.to( self.view, {delay=350, time=500, x=self.view.contentWidth/2-200,transition=easing.inExpo, onComplete=back} )
end

function Enemy:destroy( ... )
	transition.cancel(self.view)
	self.view:removeSelf( )
	self.view = nil
	self.box:removeSelf( )
	self.box = nil
end

return Enemy