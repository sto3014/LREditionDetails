require "PluginInit"

local logger = require("Logger")

-------------------------------------------------------------------------------

local PrintEditionMetadataDefinition = {
    metadataFieldsForPhotos = {
        {
            id = 'siteId',
        },

        {
            id = 'at.homebrew.lrprintedition.lrcatalogname',
            title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/LRCatalogName=LR Catalog Name",
            dataType = 'string',
            browsable = true,
            searchable = true,
            readOnly = true,
        },
        {
            id = 'at.homebrew.lrprintedition.lrphotoid',
            title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/LRPhotoID=LR Photo ID",
            dataType = 'string',
            browsable = true,
            searchable = true,
            readOnly = true,
        },
        {
            id = 'at.homebrew.lrprintedition.excatalogname',
            title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/ExCatalogName=Catalog Name",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
        {
            id = 'at.homebrew.lrprintedition.copy',
            title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Copy=Copy",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
        {
            id = 'at.homebrew.lrprintedition.edition',
            title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Edition=Edition",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
        {
            id = 'at.homebrew.lrprintedition.mark',
            title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Mark=Mark",
            dataType = 'string',
            browsable = true,
            searchable = true,
            values = {
                {
                    value = 'None',
                    title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Mark/none=None",
                },
                {
                    value = 'E.H.',
                    title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Mark/eh=E.H.",
                },
                {
                    value = 'H.C.',
                    title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Mark/hc=H.C.",
                },
                {
                    value = 'A.P.',
                    title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Mark/ap=A.P.",
                },
                {
                    value = 'P.P.',
                    title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Mark/pp=P.P.",
                },
            },
        },
        {
            id = 'at.homebrew.lrprintedition.comment',
            title = LOC "$$$/LRPrintEdition/Metadata/Fields/Display/Comment=Comment",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
    },

    schemaVersion = 1, -- must be a number, preferably a positive integer


    updateFromEarlierSchemaVersion = function(catalog, previousSchemaVersion)
        -- Note: This function is called from within a catalog:withPrivateWriteAccessDo
        -- block. You should not call any of the with___Do functions yourself.

        catalog:assertHasPrivateWriteAccess("PrintEditionMetadataDefinition.updateFromEarlierSchemaVersion")

        if previousSchemaVersion == 1 then

            -- Retrieve photos that have been used already with the custom metadata.

            local photosToMigrate = catalog:findPhotosWithProperty(PluginInit.pluginID, 'siteId')

            -- Optional:  can add property version number here.

            for _, photo in ipairs(photosToMigrate) do
                -- ignore
            end
        elseif previousSchemaVersion == 2 then

            -- Optional area to do further processing etc.
        end
    end,

}

-------------------------------------------------------------------------------

return PrintEditionMetadataDefinition
