-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------





local composer = require "composer"

composer.recycleOnSceneChange = true

-- load scenetemplate.lua
composer.gotoScene( "app.MainScene" )

print('```````````````````````````````````````````````````````')


print("SYSTEM "..system.getInfo('platformName'))

-- display.setDefault( "anchorX", 0 )
-- display.setDefault( "anchorY", 0 )

-- Runtime:addEventListener( "key", onKeyEvent )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc.):

