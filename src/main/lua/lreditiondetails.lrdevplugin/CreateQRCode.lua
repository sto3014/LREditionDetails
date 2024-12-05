--[[----------------------------------------------------------------------------
SearchLastModified.lua
------------------------------------------------------------------------------]]
-- Access the Lightroom SDK namespaces.
local LrFunctionContext = import 'LrFunctionContext'
local LrApplication = import 'LrApplication'
local LrProgressScope = import 'LrProgressScope'
local LrTasks = import 'LrTasks'
local LrPathUtils = import 'LrPathUtils'
local LrFileUtils = import 'LrFileUtils'
local LrPrefs = import 'LrPrefs'
local LrView = import 'LrView'
local LrBinding = import 'LrBinding'
local LrDialogs = import 'LrDialogs'
-- Logger
local logger = require("Logger")

local notProcessedPhotos = {}
local failedPhotos = {}

--[[---------------------------------------------------------------------------
Error dialog
-----------------------------------------------------------------------------]]
function eQRCreation(context)
    local factory = LrView.osFactory()
    local props = LrBinding.makePropertyTable(context)

    props.error = LOC("$$$/LREditionDetails/Msg/ErrorQRCode=The creation of ^1 QR code(s) failed.", #notProcessedPhotos + #failedPhotos)
    props.errorNotProcessed = LOC("$$$/LREditionDetails/Msg/ErrorNotProcessed=^1 photo(s) were/was not processed because the QR code property was missing:", #notProcessedPhotos)
    props.errorFailed = LOC("$$$/LREditionDetails/Msg/ErrorFailed=For ^1 photo(s) the encoding of the QR code failed. Please check QR code and settings of:", #failedPhotos)
    props.linesNotProcessed = #notProcessedPhotos +3
    props.linesFailed = #failedPhotos +3
    props.listNotProcessed = ""
    props.listFailed = ""
    for  _,photo in pairs(notProcessedPhotos) do
        local fileName = photo:getFormattedMetadata("fileName")
        props.listNotProcessed = props.listNotProcessed .. fileName .. "\n"
    end
    for  _,photo in pairs(failedPhotos) do
        local fileName = photo:getFormattedMetadata("fileName")
        props.listFailed = props.listFailed .. fileName .. "\n"
    end

    local content = factory:column {
        spacing = factory:control_spacing(),
        bind_to_object = props,
        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LrView.bind("error"),
                width_in_chars= 80,
                height_in_lines=1,
                alignment = "center",
                font = "<system/bold>",
            },

        },
        factory:separator {
            fill_horizontal = 1,
        },
        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LrView.bind("errorNotProcessed"),
                width_in_chars= 80,
                height_in_lines=1,
                font = "<system/bold>",
            },
        },

        factory:row{
            factory:edit_field {
                alignment = "left",
                enabled = true,
                width_in_chars=80,
                height_in_lines= LrView.bind("linesNotProcessed"),
                value = LrView.bind("listNotProcessed"),
            },
        },
        factory:separator {
            fill_horizontal = 1,
        },
        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LrView.bind("errorFailed"),
                width_in_chars= 80,
                height_in_lines=1,
                font = "<system/bold>",
            },
        },

        factory:row{
            factory:edit_field {
                alignment = "left",
                enabled = true,
                width_in_chars=80,
                height_in_lines= LrView.bind("linesFailed"),
                value = LrView.bind("listFailed"),
            },
        },
    }

    local r = LrDialogs.presentModalDialog {
        title = LOC("$$$/LREditionDetails/Msg/ErrorQRCodes=Error creating QR codes"),
        contents = content
    }
    logger.trace("r=" .. tostring(r))
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
function getSubTitle(prefs, photo)
    local subTitle = ""
    if (prefs.qrSubTitle) then
        logger.trace("qrSubTitleProperty=" .. tostring(prefs.qrSubTitleProperty))

        local property
        if (prefs.qrSubTitleProperty == "catalogname" or prefs.qrSubTitleProperty == "lotno" or prefs.qrSubTitleProperty == "edition" or prefs.qrSubTitleProperty == "qrcode") then
            property = photo:getPropertyForPlugin(_PLUGIN, prefs.qrSubTitleProperty)
            if (prefs.qrSubTitleProperty == "edition") then
                local signature = photo:getPropertyForPlugin(_PLUGIN, "mark")
                if (signature ~= nil and signature ~= "") then
                    property = property .. " " .. signature
                end
            end
        else
            property = photo:getFormattedMetadata(prefs.qrSubTitleProperty)
        end
        logger.trace("property=" .. tostring(property))

        subTitle = tostring(property)

    end
    logger.trace("subTitle=" .. subTitle)
    return subTitle
end
--[[---------------------------------------------------------------------------

-----------------------------------------------------------------------------]]
function getMainTitle(prefs, photo)
    local mainTitle = ""
    if (prefs.qrMainTitle) then
        logger.trace("qrMainTitleProperty=" .. tostring(prefs.qrMainTitleProperty))
        local property
        if (prefs.qrMainTitleProperty == "catalogname" or prefs.qrMainTitleProperty == "lotno" or prefs.qrMainTitleProperty == "edition" or prefs.qrMainTitleProperty == "qrcode") then
            property = photo:getPropertyForPlugin(_PLUGIN, prefs.qrMainTitleProperty)
            logger.trace("property=" .. tostring(property))
            if (prefs.qrMainTitleProperty == "edition") then
                local signature = photo:getPropertyForPlugin(_PLUGIN, "mark")
                if (signature ~= nil and signature ~= "") then
                    property = property .. " " .. signature
                end
            end
        else
            property = photo:getFormattedMetadata(prefs.qrMainTitleProperty)
        end
        logger.trace("property=" .. tostring(property))

        mainTitle = tostring(property)

    end
    logger.trace("mainTitle=" .. mainTitle)
    return mainTitle
end
--[[---------------------------------------------------------------------------
Async task
-----------------------------------------------------------------------------]]
function TaskFunc(context)
    logger.trace("TaskFunc")
    local activeCatalog = LrApplication.activeCatalog()
    local photos = activeCatalog:getTargetPhotos()
    local progress = LrProgressScope({
        title = LOC("$$$/LREditionDetails/Menu/Library/CreateQRCodeProgress=Create QR Code for ^1 photo(s)", #photos),
        functionContext = context
    })

    local qrgen, picPath
    if WIN_ENV then
        qrgen = LrPathUtils.getStandardFilePath("home") .. "\\Appdata\\Local\\Programs\\QRGen\\qrgen.cmd"
        picPath = LrPathUtils.child(LrPathUtils.getStandardFilePath("pictures"), "QRCodes") .. "\\"
    else
        qrgen = LrPathUtils.getStandardFilePath("home") .. "/Library/Application Support/QRGen/qrgen.sh"
        picPath = LrPathUtils.child(LrPathUtils.getStandardFilePath("pictures"), "QRCodes") .. "/"
    end

    LrFileUtils.createAllDirectories(picPath)

    local processedPhotos = 0;
    notProcessedPhotos = {}
    failedPhotos = {}
    local count = 0;
    local prefs = LrPrefs.prefsForPlugin()
    for _, photo in ipairs(photos) do
        local qrcode = tostring(photo:getPropertyForPlugin(_PLUGIN, "qrcode"))
        local  fileName = photo:getFormattedMetadata("fileName")
        logger.trace("fileName=" .. fileName)
        if qrcode ~= "nil" and qrcode ~= "" then
            -- main title
            local mainTitle = getMainTitle(prefs, photo)
            local mainTitleOption
            if mainTitle ~= "" then
                mainTitleOption = " -m " .. '"' .. mainTitle .. '"'
            else
                mainTitleOption = ""
            end

            -- sub title
            local subTitle = getSubTitle(prefs,photo)
            local subTitleOption
            if subTitle ~= "" then
                subTitleOption = " -s " .. '"' .. subTitle .. '"'
            else
                subTitleOption=""
            end

            -- command
            local cmd = '"' .. qrgen .. '"'
                    .. " -c " .. '"' .. qrcode .. '"'
                    .. " -o " .. '"' .. picPath .. fileName .. ".qr" .. '"'
                    .. " -w " .. tostring(prefs.qrWidth)
                    .. " -h " .. tostring(prefs.qrHeight)
                    .. " -t " .. tostring(prefs.qrTransparent)
                    .. " -e " .. tostring(prefs.qrErrorCorrectionLevel)
                    .. " -g " .. tostring(prefs.qrGenerator)
                    .. mainTitleOption
                    .. subTitleOption

            if WIN_ENV then
                cmd = 'cmd /c "' .. cmd .. '"'
            end
            logger.trace("execute " .. cmd)
            local result = LrTasks.execute(cmd);
            logger.trace("result=" .. result)
            if result == 0 then
                count = count + 1
            else
                logger.trace("Error: Encoding of QR code " .. qrcode .. " failed for photo " .. fileName)
                table.insert(failedPhotos, photo)
            end
        else
            logger.trace("Error: QR-Code is missing for photo " .. fileName)
            table.insert(notProcessedPhotos, photo)
        end
        processedPhotos = processedPhotos + 1
        progress:setPortionComplete(processedPhotos, #photos)
    end
    --end)
    progress:done()

    if (#notProcessedPhotos > 0 or #failedPhotos >0) then
        LrFunctionContext.callWithContext("notProcessedPhotos", eQRCreation)
    end

    if count > 0 then
        activeCatalog:triggerImportUI(picPath)
    end
end

--[[---------------------------------------------------------------------------
Main function
-----------------------------------------------------------------------------]]
LrFunctionContext.callWithContext("createQRCode", function(context)

    local prefs = LrPrefs.prefsForPlugin()

    local factory = LrView.osFactory()
    local props = LrBinding.makePropertyTable(context)
    props.qrWidth = prefs.qrHeight
    props.qrHeight = prefs.qrWidth
    props.qrTransparent = prefs.qrTransparent
    props.qrMainTitle = prefs.qrMainTitle
    props.qrSubTitle = prefs.qrSubTitle
    props.qrMainTitleProperty = prefs.qrMainTitleProperty
    props.qrSubTitleProperty = prefs.qrSubTitleProperty
    props.qrMainTitlePropertyEnabled = prefs.qrMainTitlePropertyEnabled
    props.qrSubTitlePropertyEnabled = prefs.qrSubTitlePropertyEnabled
    props.qrErrorCorrectionLevel = prefs.qrErrorCorrectionLevel
    props.qrGenerator = prefs.qrGenerator
    props.qrSetHeightSeparately = prefs.qrSetHeightSeparately

    if ( props.qrSetHeightSeparately == false) then
        props.qrHeight = props.qrWidth
    end

    -- Create the contents for the dialog.
    local content = factory:column {
        spacing = factory:control_spacing(),
        bind_to_object = props,

        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/IncludeMainTitle=Include main title"
            },
            factory:checkbox {
                value = LrView.bind("qrMainTitle"),
            },
            factory:popup_menu({
                enabled = LrView.bind("qrMainTitle"),
                value = LrView.bind("qrMainTitleProperty"),
                width_in_chars = 10,
                items = {
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/title=Title"),
                        value = "title"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/fileName=Filename"),
                        value = "fileName"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/copyright=Copyright"),
                        value = "copyright"
                    },

                    {
                        title = LOC("$$$/LREditionDetails/Dialog/artist=Artist"),
                        value = "artist"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Metadata/Fields/Display/CatalogName=Catalog name"),
                        value = "catalogname"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Metadata/Fields/Display/LotNo=Lot number"),
                        value = "lotno"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Metadata/Fields/Display/Edition=Run size"),
                        value = "edition"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Metadata/Fields/Display/QRCode=OR code"),
                        value = "qrcode"
                    },
                }
            })
        },
        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/IncludeSubTitle=Include subtitle",
            },
            factory:checkbox {
                value = LrView.bind("qrSubTitle"),
            },
            factory:popup_menu({
                enabled = LrView.bind("qrSubTitle"),
                value = LrView.bind("qrSubTitleProperty"),
                width_in_chars = 10,
                items = {
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/title=Title"),
                        value = "title"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/fileName=Filename"),
                        value = "fileName"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/copyright=Copyright"),
                        value = "copyright"
                    },

                    {
                        title = LOC("$$$/LREditionDetails/Dialog/artist=Artist"),
                        value = "artist"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/catlogname=Catalog name"),
                        value = "catalogname"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/lotno=Lot number"),
                        value = "lotno"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/edition=Run size"),
                        value = "edition"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Metadata/Fields/Display/QRCode=OR code"),
                        value = "qrcode"
                    },
                }
            })

        },

        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/With=Width of image",
            },
            factory:edit_field {
                width_in_digits = 4,
                alignment = "right",
                min = 50,
                max = 9999,
                precision = 0, value = LrView.bind("qrWidth"),
                validate = function( view, value )
                    if props.qrSetHeightSeparately == false then
                        props.qrHeight = value
                    end
                    return true, value
                end
            },
            factory:static_text {
                alignment = "left",
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/Pixel=px",
            },
        },
        factory:row {
            factory:static_text {
                alignment = "left",
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/SetHeightSeparately=Set height separately",
            },
            factory:checkbox {
                alignment = "left",
                value = LrView.bind("qrSetHeightSeparately"),

            },
        },

        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/Height=Height of image",
            },
            factory:edit_field {
                width_in_digits = 4,
                alignment = "right",
                min = 50,
                max = 9999,
                value = LrView.bind("qrHeight"),
                enabled = LrView.bind("qrSetHeightSeparately"),
            },
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/Pixel=px",
            },
        },
        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/Transparent=Transparent Background",
            },
            factory:checkbox {
                value = LrView.bind("qrTransparent"),
            },
        },

        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/ErrorCorrectionLevel=Error correction level",
            },

            factory:popup_menu({
                value = LrView.bind("qrErrorCorrectionLevel"),
                width_in_chars = 4,
                items = {
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/QRCode/ErrorCorrectionLevelL=Low"),
                        value = "1"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/QRCode/ErrorCorrectionLevelM=Medium"),
                        value = "0"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/QRCode/ErrorCorrectionLevelQ=Quartile"),
                        value = "3"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/QRCode/ErrorCorrectionLevelH=High"),
                        value = "2"
                    },
                }
            })

        },
        factory:row {
            factory:static_text {
                width = LrView.share("LabelWidth"),
                title = LOC "$$$/LREditionDetails/Dialog/QRCode/Generator=Generator",
            },

            factory:popup_menu({
                value = LrView.bind("qrGenerator"),
                width_in_chars = 4,
                items = {
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/QRCode/GeneratorNayuki=Nayuki"),
                        value = "nayuki"
                    },
                    {
                        title = LOC("$$$/LREditionDetails/Dialog/QRCode/GeneratorZxing=Zxing"),
                        value = "zxing"
                    },
                }
            })

        },
    } -- content

    -- Display dialog
    local r = LrDialogs.presentModalDialog {
        title = LOC "$$$/LREditionDetails/Dialog/QRCode/Title=QR Code",
        contents = content
    }

    -- Result handling
    logger:trace("Result of dialog: " .. r)
    if (r == "ok") then
        prefs = LrPrefs.prefsForPlugin()

        prefs.qrWidth = props.qrWidth
        prefs.qrHeight = props.qrHeight
        prefs.qrTransparent = props.qrTransparent
        prefs.qrMainTitle = props.qrMainTitle
        prefs.qrSubTitle = props.qrSubTitle
        prefs.qrMainTitleProperty = props.qrMainTitleProperty
        prefs.qrSubTitleProperty = props.qrSubTitleProperty
        prefs.qrMainTitlePropertyEnabled = props.qrMainTitlePropertyEnabled
        prefs.qrSubTitlePropertyEnabled = props.qrSubTitlePropertyEnabled
        prefs.qrGenerator = props.qrGenerator
        prefs.qrErrorCorrectionLevel = props.qrErrorCorrectionLevel
        prefs.qrSetHeightSeparately = props.qrSetHeightSeparately

        if (  prefs.qrSetHeightSeparately == false) then
            prefs.Height = prefs.qrWidth
        end

        logger.trace("qrMainTitle=" .. tostring(prefs.qrMainTitle))
        LrFunctionContext.postAsyncTaskWithContext("Create QR Code", TaskFunc)

    end

end) -- end main function



