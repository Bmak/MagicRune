local composer = require( "composer" )
local Tile = require("app.field.Tile")

local TileControl = {}

local mainBox = nil
local grid = nil
local tiles = nil

local ROW = 4
local COL = 6

function TileControl:new()
	self.__index = self
  return setmetatable(TileControl, self)
end

function TileControl:init()
	print( "INIT TILE CONTROL" )

	local group = composer.getScene("app.GameScene").view
	self.mainBox = display.newGroup()
	self.grid = display.newGroup( )

	local function killTouches(event)
		return true
	end
	self.mainBox:addEventListener( "touch", killTouches )

	self.mainBox:insert(self.grid)

	self:initTiles()
	self.grid.x = 0
	self.grid.y = display.contentHeight - self.grid.height - 40

end

local function onSelectItem(event)
	--TODO
end

function TileControl:initTiles( ... )
	self.tiles = {}

	local offX = 0
   	local offY = 0

	for i=1,6 do
		for j=1,6 do
			local item = Tile:new()

			table.insert( self.tiles, item )

			item:init()
			item.mainBox:addEventListener( "tileSelected", onSelectItem )



			item.mainBox.x = offX * (85)
			item.mainBox.y = offY * (85)

			offX = offX + 1
			if offX >= 6 then
				offY = offY + 1
				offX = 0
			end
			self.grid:insert(item.mainBox)
		end
	end

end


return TileControl