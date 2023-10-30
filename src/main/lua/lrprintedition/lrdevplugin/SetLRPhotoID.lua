--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'

-- Logger
local logger = require("Logger")

--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("TaskFunc")

    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()
    logger.trace("Photos selected=" .. photos)
    for _, photo in ipairs(photos) do
        local existingID = photo:getPropertyForPlugin(_PLUGIN, 'at.homebrew.lrprintedition.lrphotoid')
        if ( not existingID or existingID < 0) then
            local photoID = photo:localIdentifier()
            logger.trace("photo id=" .. photoID  )
            photo:setPropertyForPlugin(_PLUGIN, 'at.homebrew.lrprintedition.lrphotoid', photoID)
        end
    end
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("setLRPhotoID", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Set LR Photo ID", TaskFunc)
end) -- end main function



