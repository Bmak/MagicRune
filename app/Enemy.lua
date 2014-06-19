local composer = require("composer")


local Enemy = {
	
}

local box = nil
local view = nil
local lifesTxt = nil
local maxLifes = nil
local lifes = nil
local abils = nil
local abilsCont = nil

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

	if composer.gameType == "app.GameScene" then
		self:initAbils(type + 1)
	end

	self.box.x = display.contentWidth
	transition.to(self.box, {time=300, x=display.contentWidth - self.box.width,transition=easing.aseInOutBounce})

	
end

function Enemy:initAbils(num)
	self.abils = {}
	self.abilsCont = display.newGroup( )


	for i=0,num do
		local rnd = math.round( 1+math.random( )*5 ) 
		local abil = display.newImage("i/tile/"..rnd..".png")
		abil.anchorX = 0.5
		abil.anchorY = 0.5
		abil.xScale = 0.4
		abil.yScale = 0.4
		abil.x = i * (abil.contentWidth+5)

		self.abilsCont:insert(abil)
		table.insert( self.abils, abil )
	end
	self.abilsCont.anchorX = 0.5
	self.abilsCont.x = self.view.x + 20 - self.abilsCont.contentWidth/2
	self.abilsCont.y = self.view.contentHeight + 30
	self.box:insert(self.abilsCont)
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

	transition.to(self.view, { time=700, yScale=0.1, alpha=0.3,onComplete=kill})
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
	
	--Abils animation

	if composer.gameType == "app.GameScene" then

		local rnd = math.round(1+ math.random( )*(table.maxn(self.abils)-1) )
		
		local sel = display.newImage( "i/asdasd.png")
		sel.xScale = 0.2
		sel.yScale = 0.2
		self.view.anchorX = 0.5
		sel.x = self.abils[rnd].x
		sel.y = self.abils[rnd].y

		self.abilsCont:insert(1,sel)
		sel.alpha = 0

		local function removeSel( ... )
			sel:removeSelf( )
			sel = nil
		end
		local function hideSel( ... )
			transition.to( sel, {delay=800, time=100, alpha=0, onComplete=removeSel} )
		end
		transition.to( sel, { time=100, alpha=1, onComplete=hideSel} )
	end

	--View animation
	local function back( ... )
		transition.to( self.view, { time=300, x=self.view.contentWidth/2} )
		target:setDamage(damage)
	end

	transition.to( self.view, {delay=250, time=500, x=self.view.contentWidth/2-200,transition=easing.inExpo, onComplete=back} )
end

function Enemy:destroy( ... )
	transition.cancel(self.view)
	self.view:removeSelf( )
	self.view = nil
	self.box:removeSelf( )
	self.box = nil
	self.abilsCont:removeSelf( )
	self.abils = nil
	self.abilsCont = nil
end

return Enemy