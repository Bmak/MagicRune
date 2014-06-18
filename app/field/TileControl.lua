local composer = require( "composer" )
local Tile = require("app.field.Tile")
local widget = require("widget")
local hero = require("app.Hero")
local enemy = require("app.Enemy")


local TileControl = {}

local mainBox = nil
local grid = nil
local columnsCont = nil --{{}}
local tiles = nil --{{}}
local selectedTiles = nil
local linesCont = nil
local matrix = nil
local lastSelect = nil
local selectionMode = false
local victim = nil
local attacker = nil

local mode = nil

local ROW = 4
local COL = 6
local TILE_SIZE = nil

function TileControl:new()
	self.__index = self
  return setmetatable(TileControl, self)
end

function TileControl:init(mode)
	self.TILE_SIZE = 85
	self.mode = mode

	local group = composer.getScene(mode).view
	self.mainBox = display.newGroup()
	self.grid = display.newGroup( )


	local function killTouches(event)
		-- print("MAIN "..event.phase)

		-- display.getCurrentStage():setFocus( nil )
    	-- self.mainBox.isFocus = false
    	-- group.isFocus = false


    	if event.phase == "ended" or event.phase == "cancelled" and self.selectionMode == true then
    		self:acceptTiles(event)
    	end

		return true
	end
	self.mainBox:addEventListener( "touch", killTouches )
	group:addEventListener( "touch", killTouches )

	self.mainBox:insert(self.grid)

	
	self:initTiles()
	self.grid.x = (display.contentWidth - self.grid.width)/2
	self.grid.y = display.contentHeight - self.TILE_SIZE - 10
	-- self.grid.anchorX = self.grid.width
	-- self.grid.anchorY = self.grid.height
	local mask = graphics.newMask("i/mask.png")
	self.grid:setMask(mask)
	--self.grid.isHitTestMasked = false
	self.grid.maskX = self.grid.width/2
	self.grid.maskY = -self.TILE_SIZE-70


	self.linesCont = display.newGroup( )
	self.mainBox:insert(self.linesCont)

	self:initBtns()

	group:insert(self.mainBox)
end


function TileControl:onSelectItem(event)
	-- print("SEL ID "..event.target.ind.."/"..event.target.column)

	if event.target ~= self.lastSelect then
		if event.target == self.selectedTiles[table.maxn( self.selectedTiles)-1] and event.target.selState == true then
			self.selectedTiles[table.maxn( self.selectedTiles)]:setSelect(false)
			table.remove(self.selectedTiles, table.maxn( self.selectedTiles))

			self.linesCont:remove(self.linesCont.numChildren)
			self.linesCont:remove(self.linesCont.numChildren)

			self.lastSelect = self.selectedTiles[table.maxn( self.selectedTiles)]

			return
		end

	end

	if hero:getNumMoves() == table.maxn( self.selectedTiles ) then return end

	if self:checkSelect(event.target) == false then
		return
	end

	if (table.indexOf( self.selectedTiles, event.target) == nil) then
		table.insert( self.selectedTiles, event.target )
		event.target:setSelect(true)
		self:setSelectItemToBox(event.target)

		self.lastSelect = event.target
	end

	self.selectionMode = true

	-- display.getCurrentStage():setFocus( self )
    -- self.isFocus = true

	-- print("SELECT ITEMS "..table.maxn(self.selectedTiles))
end

function TileControl:checkSelect(target)
	if self.lastSelect ~= nil then
		if target.column == self.lastSelect.column or target.column == self.lastSelect.column-1 or
			target.column == self.lastSelect.column+1 then
			if target.ind == self.lastSelect.ind or target.ind == self.lastSelect.ind-1 or
				target.ind == self.lastSelect.ind+1 then
				return true
			end
		end
	else return true end

	return false
end

function TileControl:setSelectItemToBox(item)
	local dot = display.newCircle( 5, 5, 10 )
	dot:setFillColor(1, 0, 0, 0.6 )
	dot.x, dot.y = item.selMask:localToContent( 0, 0 )
	self.linesCont:insert(dot)

	local len = table.maxn(self.selectedTiles)
	if len > 1 then
		local prevItem = self.selectedTiles[len-1]
		local dx,dy = prevItem.selMask:localToContent( 0, 0 )
		local line = display.newLine(dot.x, dot.y, dx, dy )
		line:setStrokeColor( 1, 0, 0, 0.6 )
		line.strokeWidth = 6
		self.linesCont:insert(line)
	end
end

function TileControl:showOpponentMove()

	local pattern = {}
	local index = -1

	for k,tiles in pairs(self.tiles) do
		index = -1
		local temp = {}
		for v,tile in pairs(tiles) do
			-- print(tile.ind.."/"..tile.column.."/"..tile.id)

			if index == -1 then
				index = tile.id
			end

			if index == tile.id then
				table.insert( temp, tile )
				if table.maxn( temp ) > table.maxn( pattern ) then
					pattern = temp
				end 
			else
				temp = {}
				index = tile.id
				table.insert( temp, tile )
			end
			
		end

		if table.maxn( pattern ) >= 2 then
			self.selectedTiles = pattern
			for s,op in pairs(self.selectedTiles) do
				op:setSelect(true)
				self:setSelectItemToBox(op)

				self.lastSelect = op
			end

			local function onAcc( ... )
				self:acceptTiles()
			end
			transition.to(self, { time=400, onComplete=onAcc})
			
			return
		end

	end
end

function TileControl:enablePlayer(value)
	if value == true then
		display.getCurrentStage():setFocus(nil)
		-- display.getCurrentStage().isFocus = false
	else 
		display.getCurrentStage():setFocus(display.getCurrentStage())
	end
end


function TileControl:acceptTiles(e)
	local numTiles = table.maxn(self.selectedTiles)

	if table.maxn( self.selectedTiles ) <= 1 then
		for k,item in pairs(self.selectedTiles) do
			item:setSelect( false )
		end
		self.selectedTiles = {}
		self.lastSelect = nil
		self.selectionMode = false

		local slen = self.linesCont.numChildren
		for i=0,slen do
			self.linesCont:remove(slen-i)
		end

		return
	end

	local function removeLock( ... )
		self:enablePlayer(true)
	end

	local function oppMove()

		if enemy.state == "killed" then
			removeLock()
			return
		end

		if self.mode == "app.GameScene" then 
			self.attacker = enemy
			self.victim = hero
			self.attacker:attack(self.victim,self.attacker:getDamage(2+math.round(math.random()*3)))
			timer.performWithDelay( 1000, removeLock )
			
		elseif self.mode == "app.MultiScene" then
			self:showOpponentMove()
		end
	end


	if self.selectionMode == true then
		self:enablePlayer(false)
		transition.to(self.mainBox, { time=1500,onComplete=oppMove})
		
		self.attacker = hero
		self.victim = enemy
	else
		timer.performWithDelay( 1000, removeLock )
		self.attacker = enemy
		self.victim = hero
	end

	self.attacker:attack(self.victim,self.attacker:getDamage(numTiles))

	self.selectionMode = false

	local col = 0
	local id = 0
	for k,item in pairs(self.selectedTiles) do
		col = item.column
		id = table.indexOf( self.tiles[col], item )
		table.remove( self.tiles[col], id )
		item:getToHero(k,self.attacker,self.mode)
	end
	self.selectedTiles = {}
	self.lastSelect = nil


	local slen = self.linesCont.numChildren
	for i=0,slen do
		self.linesCont:remove(slen-i)
	end


	local function update( ... )
		self:updateGrid()
	end

	timer.performWithDelay( 200, update )
end

function TileControl:updateGrid()
	local len = 0
	local tile = nil
	local count = 0
	local goToY = nil

	local function onSelect(event)
   		self:onSelectItem(event)
   	end
   	local function onEndSelect(event)
   		self:acceptTiles(event)
   	end

	for k,tiles in pairs(self.tiles) do
		count = 0
		for i=1,6 do
			if (table.maxn(tiles) < i) then
				tile = Tile:new()
				tile:init(i,k)
				table.insert( tiles, tile )

				count = count + 1
				tile.mainBox.y = (count+5) * -self.TILE_SIZE
   				tile.mainBox:addEventListener( "tileSelected", onSelect)
   				tile.mainBox:addEventListener( "endSelect", onEndSelect)
   				self.columnsCont[k]:insert(tile.mainBox)
			else
				tile = tiles[i]
				tile.ind = i
			end
			goToY = (i-1) * -self.TILE_SIZE
			if goToY ~= tile.mainBox.y then
				transition.to( tile.mainBox, {delay=(i-1)*50, y=goToY,transition=easing.inExpo, time=300})
			end
			
		end
	end
end

function TileControl:clearTiles()
	for k,item in pairs(self.selectedTiles) do
		item:setSelect(false)
	end
	self.selectedTiles = {}

	local slen = self.linesCont.numChildren
	for i=0,slen do
		self.linesCont:remove(slen-i)
	end
end

function TileControl:initBtns()
	-- local function accTiles()
	-- 	self:acceptTiles()
	-- end

	-- local button = widget.newButton( {
	-- 	width = 100,
	-- 	height = 50,
	-- 	label = "accept",
	-- 	labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
	-- 	fontSize = 20,
	-- 	emboss = true,
	-- 	defaultFile = "i/start_btn.png",
	-- 		overFile = "i/start_btn.png",
	-- 	onRelease = accTiles
	-- } )

	-- button.x = display.contentWidth - button.contentWidth - 10
	-- button.y = self.grid.y - self.grid.height
	-- self.mainBox:insert( button )

	-- local function clTiles()
	-- 	self:clearTiles()
	-- end

	-- local clearBtn = widget.newButton( {
	-- 	width = 100,
	-- 	height = 50,
	-- 	label = "clear",
	-- 	labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
	-- 	fontSize = 20,
	-- 	emboss = true,
	-- 	defaultFile = "i/start_btn.png",
	-- 		overFile = "i/start_btn.png",
	-- 	onRelease = clTiles
	-- } )

	-- clearBtn.x = button.x
	-- clearBtn.y = button.y + clearBtn.contentHeight + 10
	-- self.mainBox:insert( clearBtn )
end

function TileControl:initTiles( ... )
	self.tiles = {}
	self.columnsCont = {}
	self.selectedTiles = {}
	self.matrix = {}


	local offX = 0
   	local offY = 0

   	local function onSelect(event)
   		self:onSelectItem(event)
   	end
	local function onEndSelect(event)
   		self:acceptTiles(event)
   	end
   	
   	for i=1,6 do
   		local column = {}
   		local mtr = {}
   		local spr = display.newGroup( )
   		for j=1,6 do
   			local item = Tile:new()
   			item:init(j,i)

   			table.insert( mtr, item.id )

   			item.mainBox.y = (j-1) * -self.TILE_SIZE
   			item.mainBox:addEventListener( "tileSelected", onSelect)
   			item.mainBox:addEventListener( "endSelect", onEndSelect)

   			table.insert( column, item )
   			spr:insert(item.mainBox)
   			spr.x = (i-1) * self.TILE_SIZE
   			spr.y = 0
   		end
   		table.insert( self.tiles, column )
   		table.insert( self.columnsCont, spr )
   		table.insert( self.matrix, mtr )
   		self.grid:insert(spr)

   	end
end

function TileControl:destroy( ... )
	self.mainBox:removeSelf( )
end

return TileControl