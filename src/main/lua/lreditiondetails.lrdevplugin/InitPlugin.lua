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
    prefs.qrWidth = nil
    prefs.qrHeight = nil
    prefs.qrTransparant = nil
    prefs.qrMainTitle = nil
    prefs.qrSubTitle = nil
    prefs.qrMainTitleProperty = nil
    prefs.qrSubTitleProperty = nil
    prefs.qrMainTitlePropertyEnabled = nil
    prefs.qrSubTitlePropertyEnabled = nil
    prefs.qrErrorCorrectionLevel=nil
    prefs.qrGenerator=nil

end

-------------------------------------------------------------------------------

local function init()
    -- resetPrefs()

    logger.trace("Init plug-in")
    local prefs = LrPrefs.prefsForPlugin()
    if prefs.qrWidth == nil then
        prefs.qrWidth = 200
    end
    if prefs.qrHeight == nil then
        prefs.qrHeight = 200
    end
    if prefs.qrTransparent == nil then
        prefs.qrTransparent = false
    end
    if prefs.qrMainTitle == nil then
        prefs.qrMainTitle = true
    end
    if prefs.qrSubTitle == nil then
        prefs.qrSubTitle = true
    end
    if prefs.qrMainTitleProperty == nil then
        prefs.qrMainTitleProperty = "title"
    end
    if prefs.qrSubTitleProperty == nil then
        prefs.qrSubTitleProperty = "qrcode"
    end
    if prefs.qrMainTitlePropertyEnabled == nil then
        prefs.qrMainTitlePropertyEnabled = true
    end
    if prefs.qrSubTitlePropertyEnabled == nil then
        prefs.qrSubTitlePropertyEnabled = true
    end
    if prefs.qrErrorCorrectionLevel == nil then
        prefs.qrErrorCorrectionLevel="1"
    end
    if prefs.qrGenerator == nil or prefs.qrGenerator=="" then
        prefs.qrGenerator="nayuki"
    end
    logger.trace("Init done.")
end

-------------------------------------------------------------------------------

init()

