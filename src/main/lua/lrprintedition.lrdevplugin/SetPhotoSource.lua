--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrPathUtils = import 'LrPathUtils'

-- Logger
local logger = require("Logger")

--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("TaskFunc")

    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()
    activeCatalog:withWriteAccessDo("Set Lightroom photo info", function()
        for _, photo in ipairs(photos) do
                local photoID = photo.localIdentifier
                logger.trace("photoID=" .. tostring(photoID))
                photo:setRawMetadata("source", tostring(photoID))
        end
    end)
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("setLRPhotoID", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Set LR Photo ID", TaskFunc)
end) -- end main function



