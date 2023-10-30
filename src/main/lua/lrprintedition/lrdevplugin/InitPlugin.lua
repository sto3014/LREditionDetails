--
-- Created by IntelliJ IDEA.
-- User: Dieter Stockhausen
-- Date: 29.10.2023
-- To change this template use File | Settings | File Templates.
-------------------------------------------------------------------------------
local LrPrefs = import "LrPrefs"

local logger = require("Logger")
-------------------------------------------------------------------------------

local InitProvider = {}

-------------------------------------------------------------------------------

local function resetPrefs()
    local prefs = LrPrefs.prefsForPlugin()
end

-------------------------------------------------------------------------------

local function init()
    -- resetPrefs()

    logger.trace("Init plug-in")
    local prefs = LrPrefs.prefsForPlugin()
    logger.trace("Init done.")
end

-------------------------------------------------------------------------------

init()

