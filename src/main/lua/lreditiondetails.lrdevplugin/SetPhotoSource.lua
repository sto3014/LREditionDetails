--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrProgressScope = import 'LrProgressScope'

-- local LrMobdebug = import 'LrMobdebug' -- Import LR/ZeroBrane debug module
-- LrMobdebug.start()

local lrutils = require("LrUtils")

-- Logger
local logger = require("Logger")

--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("set source by photo ID")

    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()

    local progress = LrProgressScope({
        title = LOC ("$$$/LREditionDetails/Menu/Library/SetSource#=Set source by photo ID for ^1 photos", #photos),
        functionContext = context
    })
    -- LrMobdebug.on()

    local catName = lrutils.getCatName()
    logger.trace("catName=" .. catName)

    activeCatalog:withWriteAccessDo("Set Lightroom photo info", function()
        for _, photo in ipairs(photos) do
                local photoID = photo.localIdentifier
                logger.trace("photoID=" .. tostring(photoID))
                photo:setRawMetadata("source", catName .. '-' .. tostring(photoID))
        end
    end)
    progress:done()
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("setLRPhotoID", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Set LR Photo ID", TaskFunc)
end) -- end main function



