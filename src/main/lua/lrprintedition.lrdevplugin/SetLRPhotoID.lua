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
    -- logger.trace("Photos selected=" .. tostring(table.getn(photos)))
    local catName = LrPathUtils.removeExtension(LrPathUtils.leafName(activeCatalog:getPath()))
    logger.trace("catName=" .. catName)
    activeCatalog:withWriteAccessDo("Set Lightroom photo info", function()
        for _, photo in ipairs(photos) do
            local existingID = photo:getPropertyForPlugin(_PLUGIN, 'lrphotoid')
            logger.trace("existingID=" .. tostring(existingID))
            --if (not existingID or existingID < 0) then
                local photoID = photo.localIdentifier
                logger.trace("photoID=" .. tostring(photoID))
                photo:setPropertyForPlugin(_PLUGIN, 'lrphotoid', tostring(photoID))
            --end
            logger.trace("lightroomCatalog=" .. tostring(photo:getPropertyForPlugin(_PLUGIN, 'lrcatalogname')))
            photo:setPropertyForPlugin(_PLUGIN, 'lrcatalogname', catName)
        end
    end)
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("setLRPhotoID", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Set LR Photo ID", TaskFunc)
end) -- end main function



