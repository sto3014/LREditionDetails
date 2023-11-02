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
    local catName = LrPathUtils.removeExtension(LrPathUtils.leafName(activeCatalog:getPath()))
    local i = string.find(catName, "-v")
    logger.trace("i=" .. tostring(i))
    if (i ~= nil and i > 1) then
        catName = string.sub(catName, 1, i - 1)
    end
    logger.trace("catName=" .. catName)
    activeCatalog:withWriteAccessDo("Set Lightroom photo catalog", function()
        for _, photo in ipairs(photos) do
            local photoID = photo.localIdentifier
            local catalogType = photo:getPropertyForPlugin(_PLUGIN, "catalogtype")
            if ( catalogType ~= nil ) then
                photo:setPropertyForPlugin(_PLUGIN, "catalogname", catName)
                logger.trace("catalogname=" .. catName)
                photo:setPropertyForPlugin(_PLUGIN, "lotno", tostring(photoID))
                logger.trace("lotno=" .. tostring(photoID))
            end
            photo:setRawMetadata("source", catName .. "-" .. tostring(photoID))
        end
    end)
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("setLRPhotoCatalog", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Set LR Photo Catalog", TaskFunc)
end) -- end main function



