local composer = require( "composer" )
local scene = composer.newScene()


local levels = {}

function scene:create( event )
	local group = self.view

	local bkg = display.newImageRect( "i/bkg.png",display.contentWidth, display.contentHeight )
	bkg.x = display.contentCenterX
	bkg.y = display.contentCenterY
	group:insert(bkg)

	local map = display.newImage( "i/map.png")
	map.xScale = display.contentWidth/map.width
	map.yScale = map.xScale

  	map.x = display.contentCenterX
	map.y = display.contentCenterY
	group:insert( map )



end

local function onSelectLevel(event)
	local btn = event.target
	function tr_end( ... )
		composer.gotoScene( composer.gameType )
	end
	function back( ... )
		transition.to( btn, { xScale=1, yScale=1,transition=easing.outBack, time=200,onComplete=tr_end})
	end
	transition.to( btn, { xScale=2, yScale=2, time=200,transition=easing.inOutBack,onComplete=back} )
end

function createLevels()
	local group = scene.view
	

	local p1 = { x=62,y=350 }
	local p2 = { x=360,y=265 }
	local p3 = { x=64,y=570 }
	local p4 = { x=390,y=690 }
	local points = {}
	table.insert( points, p1 )
	table.insert( points, p2 )
	table.insert( points, p3 )
	table.insert( points, p4 )

	for i=1,4 do
		local btn = display.newImage("i/mark.png")
		btn.anchorX = 0.5
		btn.anchorY = 0.5
		btn.x = points[i].x
		btn.y = points[i].y
		btn:addEventListener( "tap", onSelectLevel )

		group:insert(btn)
		table.insert( levels, btn )

		setMove(btn)
	end

end

function setMove(obj)
	obj.rotation = 0
	transition.to(obj, { time=2000,rotation=360,onComplete=setMove,onCompleteParams=obj})
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


		createLevels()


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

	for k,btn in pairs(levels) do
		transition.cancel(btn)
		btn:removeSelf( )
	end
	levels = nil
	
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