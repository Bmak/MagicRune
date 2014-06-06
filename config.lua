local aspectRatio = display.pixelHeight / display.pixelWidth

print("aspectRatio: "..aspectRatio)

application = {
	content = {
		width = 0,
        height = 0, 
        scale = "zoomStretch",
        fps = 30,
		
		--[[
        imageSuffix = {
		    ["@2x"] = 2,
		}
		--]]
	},

    --[[
    -- Push notifications

    notification =
    {
        iphone =
        {
            types =
            {
                "badge", "sound", "alert", "newsstand"
            }
        }
    }
    --]]    
}
