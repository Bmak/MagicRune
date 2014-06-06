----------------------------------------------------------------------------------
--
-- mainscene.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()



function scene:create( event )
	local group = self.view
    --local background = display.newImageRect( "i/intro.jpg", display.contentWidth, display.contentHeight )
   -- background.x = display.contentCenterX
   -- background.y = display.contentCenterY
    --group:insert( background )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
end

local function startGame()
		native.requestExit()
		composer.gotoScene( "app.GameScene" )
	end

function scene:show( event )
	print( "SHOW GAME SCENE" )

	local group = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.

		local text = display.newText( "TITLE OF GAME", display.contentWidth/2, display.contentWidth/2 - 100, native.systemFont, 20 )
		group:insert(text)

		local button = widget.newButton( {
			width = 100,
			height = 50,
			label = "start",
			labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
			fontSize = 20,
			emboss = true,
			defaultFile = "i/start_btn.png",
   			overFile = "i/start_btn.png",
			onRelease = startGame
		} )

		button.x = display.contentCenterX
		button.y = display.contentCenterY - button.contentHeight/2
		group:insert( button )
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

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene