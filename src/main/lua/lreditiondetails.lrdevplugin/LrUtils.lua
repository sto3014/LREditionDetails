--[[---------------------------------------------------------------------------
-- Created by Dieter Stockhausen
-- Created on 09.11.23
-----------------------------------------------------------------------------]]
local LrApplication = import 'LrApplication'
local LrPathUtils = import 'LrPathUtils'

-- Logger
local logger = require("Logger")

local lrutils = {}

--[[---------------------------------------------------------------------------
getCatName()
-----------------------------------------------------------------------------]]
function lrutils.getCatName ()
    logger.trace("getCatName start")
    local activeCatalog = LrApplication.activeCatalog()
    local catName = LrPathUtils.removeExtension(LrPathUtils.leafName(activeCatalog:getPath()))
    local i = string.find(catName, "-v")
    logger.trace("i=" .. tostring(i))
    if (i ~= nil and i > 1) then
        catName = string.sub(catName, 1, i - 1)
    end
    return catName
end

return lrutils