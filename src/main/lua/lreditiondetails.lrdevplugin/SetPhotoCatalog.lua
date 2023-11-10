--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrProgressScope = import 'LrProgressScope'
local LrDialogs = import 'LrDialogs'


local lrutils = require("LrUtils")

-- Logger
local logger = require("Logger")

--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("TaskFunc")
    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()
    local progress = LrProgressScope({
        title = LOC ("$$$/LREditionDetails/Menu/Library/SetLRPCatalogName#=Initialise Edition Details for ^1 photos", #photos),
        functionContext = context
    })
    local catName = lrutils.getCatName()
    logger.trace("catName=" .. catName)
    local processedPhotos = 0
    activeCatalog:withWriteAccessDo("Set Lightroom photo catalog", function()
        for _, photo in ipairs(photos) do
            local photoID = photo.localIdentifier
            local catalogType = photo:getPropertyForPlugin(_PLUGIN, "catalogtype")
            if (catalogType == "Lightroom" ) then
                processedPhotos = processedPhotos + 1
                photo:setPropertyForPlugin(_PLUGIN, "catalogname", catName)
                logger.trace("catalogname=" .. catName)
                photo:setPropertyForPlugin(_PLUGIN, "lotno", tostring(photoID))
                logger.trace("lotno=" .. tostring(photoID))
            end
        end
    end)
    if ( #photos ~= processedPhotos) then
        LrDialogs.message(LOC("$$$/LREditionDetails/Msg/NotAllPhotosWereProcessed=Only ^1 photo(s) of ^2 were updated. Only photos of external catalog type will be processed.", processedPhotos, #photos))
    end
    progress:done()
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("setLRPhotoCatalog", function(context)
    LrFunctionContext.postAsyncTaskWithContext("Set LR Photo Catalog", TaskFunc)
end) -- end main function



