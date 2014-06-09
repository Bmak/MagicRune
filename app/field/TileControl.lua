local composer = require( "composer" )
local Tile = require("app.field.Tile")
local widget = require("widget")

local TileControl = {}

local mainBox = nil
local grid = nil
local columnsCont = nil --{{}}
local tiles = nil --{{}}
local selectedTiles = nil

local ROW = 4
local COL = 6
local TILE_SIZE = nil

function TileControl:new()
	self.__index = self
  return setmetatable(TileControl, self)
end

function TileControl:init()
	self.TILE_SIZE = 85

	local group = composer.getScene("app.GameScene").view
	self.mainBox = display.newGroup()
	self.grid = display.newGroup( )


	local function killTouches(event)
		return true
	end
	self.mainBox:addEventListener( "touch", killTouches )

	self.mainBox:insert(self.grid)

	self:initBtns()
	self:initTiles()
	self.grid.x = (display.contentWidth - self.grid.width)/2
	self.grid.y = display.contentHeight - self.TILE_SIZE - 10
	local mask = graphics.newMask("i/mask.png")
	self.grid:setMask(mask)
	--self.grid.isHitTestMasked = false
	self.grid.maskX = self.grid.x + self.grid.width/2
	self.grid.maskY = -self.TILE_SIZE-70
end


function TileControl:onSelectItem(event)
	-- print("SEL ID "..event.target.ind.."/"..event.target.column)
	if (table.indexOf( self.selectedTiles, event.target) == nil) then
		table.insert( self.selectedTiles, event.target )
	end
end

function TileControl:acceptTiles()
	local col = 0
	local id = 0
	for k,item in pairs(self.selectedTiles) do
		col = item.column
		id = table.indexOf( self.tiles[col], item )
		table.remove( self.tiles[col], id )
		item:destroy()
	end
	self.selectedTiles = {}

-- TODO magic effects by selection tiles
	
	self:updateGrid()

end

function TileControl:updateGrid()
	local len = 0
	local tile = nil
	local count = 0
	local goToY = nil

	local function onSelect(event)
   		self:onSelectItem(event)
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
   				self.columnsCont[k]:insert(tile.mainBox)
			else
				tile = tiles[i]
				tile.ind = i
			end
			goToY = (i-1) * -self.TILE_SIZE
			if goToY ~= tile.mainBox.y then
				transition.to( tile.mainBox, {delay=(i-1)*50, y=goToY,transition=easing.inExpo, time=500})
			end
			
		end
	end
end

function TileControl:initBtns()
	local function accTiles()
		self:acceptTiles()
	end

	local button = widget.newButton( {
		width = 100,
		height = 50,
		label = "accept",
		labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
		fontSize = 20,
		emboss = true,
		defaultFile = "i/start_btn.png",
			overFile = "i/start_btn.png",
		onRelease = accTiles
	} )

	button.x = display.contentWidth - button.contentWidth - 10
	button.y = 50
	self.mainBox:insert( button )
end

function TileControl:initTiles( ... )
	self.tiles = {}
	self.columnsCont = {}
	self.selectedTiles = {}

	local offX = 0
   	local offY = 0

   	local function onSelect(event)
   		self:onSelectItem(event)
   	end
   	
   	for i=1,6 do
   		local column = {}
   		local spr = display.newGroup( )
   		for j=1,6 do
   			local item = Tile:new()
   			item:init(j,i)

   			item.mainBox.y = (j-1) * -self.TILE_SIZE
   			item.mainBox:addEventListener( "tileSelected", onSelect)

   			table.insert( column, item )
   			spr:insert(item.mainBox)
   			spr.x = (i-1) * self.TILE_SIZE
   			spr.y = 0
   		end
   		table.insert( self.tiles, column )
   		table.insert( self.columnsCont, spr )
   		self.grid:insert(spr)

   	end

	-- for i=1,6 do
	-- 	for j=1,6 do
	-- 		local item = Tile:new()

	-- 		table.insert( self.tiles, item )

	-- 		item:init()
	-- 		item.mainBox:addEventListener( "tileSelected", onSelectItem )



	-- 		item.mainBox.x = offX * (85)
	-- 		item.mainBox.y = offY * (85)

	-- 		offX = offX + 1
	-- 		if offX >= 6 then
	-- 			offY = offY + 1
	-- 			offX = 0
	-- 		end
	-- 		self.grid:insert(item.mainBox)
	-- 	end
	-- end

end


return TileControl