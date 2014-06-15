


local composer = require( "composer" )
local widget = require("widget")
local tileControl = require("app.field.TileControl")
local scene = composer.newScene()
local hero = require("app.Hero")
local enemy = require("app.Enemy")


function scene:create( event )
	local group = self.view
	local background = display.newImageRect( "i/bkg.png", display.contentWidth, display.contentHeight )
  	background.x = display.contentCenterX
	background.y = display.contentCenterY
	group:insert( background )



end

local function createField()
	tileControl:init("app.MultiScene")
end

function scene:show( event )
	local group = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.

		-- local text = display.newText( "GAME SCENE", display.contentWidth/2, display.contentWidth/2 - 100, native.systemFont, 20 )
		-- group:insert(text)
		hero:init()
		group:insert( hero.box )

		enemy:init()
		enemy.box.x = display.contentWidth - enemy.box.width
		group:insert( enemy.box )

		createField()

	end	
end





function scene:hide( event )
	local group = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
		composer.prevScene = composer.getSceneName("current")
	end	
end

function scene:destroy( event )
	local group = self.view
	
	group:removeSelf( )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end



-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "create", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroy", scene )

--display.currentStage:addEventListener( "tap", screenTap )

return scene