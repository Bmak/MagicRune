----------------------------------------------------------------------------------
--
-- mainscene.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require("widget")
local scene = composer.newScene()
local music = nil


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
	local options =
	{
	    channel=1,
	    loops=-1,
	   
	    fadein=5000,
	    
	}
	music = audio.loadSound( "s/bkg.mp3")
	audio.play(music,options)
	audio.setVolume( 0.5, { channel=1 } )
end

local function startGame()
	-- composer.gotoScene( "app.GameScene" )
	composer.gameType = "app.GameScene"
	composer.gotoScene( "app.HeroScene" )

	system.vibrate( )
end
local function startMultiGame( ... )
	-- composer.gotoScene( "app.MultiScene" )
	composer.gameType = "app.MultiScene"
	composer.gotoScene( "app.HeroScene" )

	system.vibrate( )
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

		local text = display.newText( "MAGIC RUNES", display.contentWidth/2, display.contentWidth/2 - 100, native.systemFont, 20 )
		group:insert(text)

		local button = widget.newButton( {
			width = 150,
			height = 50,
			label = "single game",
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

		local multiBtn = widget.newButton( {
			width = 150,
			height = 50,
			label = "multi game",
			labelColor = { default={ 0, 0, 0 }, over={ 0, 0, 0 } },
			fontSize = 20,
			emboss = true,
			defaultFile = "i/start_btn.png",
   			overFile = "i/start_btn.png",
			onRelease = startMultiGame
		} )

		multiBtn.x = display.contentCenterX
		multiBtn.y = button.y + button.height + 20
		group:insert( multiBtn )
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