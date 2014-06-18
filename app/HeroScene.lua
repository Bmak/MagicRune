local composer = require( "composer" )
local scene = composer.newScene()


local heroes = nil


function scene:create( event )
	local group = self.view
	local background = display.newImageRect( "i/bkg.png", display.contentWidth, display.contentHeight )
  	background.x = display.contentCenterX
	background.y = display.contentCenterY
	group:insert( background )



end


local function onSelectHero(event)
	local hero = event.target
	composer.heroType = hero.type
	function tr_end( ... )
		-- composer.gotoScene( composer.gameType )
		if composer.gameType == "app.GameScene" then
			composer.gotoScene("app.MapScene")
		elseif composer.gameType == "app.MultiScene" then
			composer.gotoScene( composer.gameType )
		end
		
	end
	function back( ... )
		transition.to( hero, { xScale=1, yScale=1,transition=easing.outBack, time=200,onComplete=tr_end})
	end
	transition.to( hero, { xScale=1.2, yScale=1.2, time=200,transition=easing.inOutBack,onComplete=back} )
end

local function createHeroes()
	local group = scene.view
	heroes = {}

	for i=0,1 do
	 	local hero = display.newImage( "i/hero"..i..".png" )
	 	hero.type = i
	 	hero.anchorX = 0.5
	 	hero.anchorY = 0.5
	 	hero.x = display.contentWidth/2
	 	hero.y = 300 + (hero.contentHeight+100) * i

	 	group:insert(hero)
	 	table.insert( heroes, hero )

	 	hero:addEventListener( "tap", onSelectHero )
	end 
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

		local text = display.newText( "SELECT HERO", display.contentWidth/2, 100, native.systemFont, 30 )
		group:insert(text)

		createHeroes()


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