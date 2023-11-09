require "PluginInit"

local logger = require("Logger")

-------------------------------------------------------------------------------

local EditionDetailsMetadataDefinition = {
    metadataFieldsForPhotos = {
        {
            id = 'siteId',
        },

        {
            id = 'catalogname',
            title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/CatalogName=Catalog",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
        {
            id = 'lotno',
            title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/LotNo=Lot",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
        {
            id = 'catalogtype',
            title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/CatalogType=Catalog Type",
            dataType = 'enum',
            browsable = true,
            searchable = true,
            values = {
                {
                    value = "External",
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/CatalogType/External=External",
                },
                {
                    value = 'Lightroom',
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/CatalogType/Lightroom=Lightroom",
                },
            },
        },

        {
            id = 'edition',
            title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Edition=Edition",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
        {
            id = 'mark',
            title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Mark=Mark",
            dataType = 'enum',
            browsable = true,
            searchable = true,
            values = {
                {
                    value = 'None',
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Mark/none=None",
                },
                {
                    value = 'E.H.',
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Mark/eh=E.H.",
                },
                {
                    value = 'H.C.',
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Mark/hc=H.C.",
                },
                {
                    value = 'A.P.',
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Mark/ap=A.P.",
                },
                {
                    value = 'P.P.',
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Mark/pp=P.P.",
                },
                {
                    value = 'E.E.',
                    title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Mark/ee=E.E.",
                },
            },
        },
        {
            id = 'comment',
            title = LOC "$$$/LREditionDetails/Metadata/Fields/Display/Comment=Comment",
            dataType = 'string',
            browsable = true,
            searchable = true,
        },
    },

    schemaVersion = 1, -- must be a number, preferably a positive integer


    updateFromEarlierSchemaVersion = function(catalog, previousSchemaVersion)
        -- Note: This function is called from within a catalog:withPrivateWriteAccessDo
        -- block. You should not call any of the with___Do functions yourself.
        logger.trace("start updateFromEarlierSchemaVersion")
        logger.trace("Previous schema version=" .. tostring(previousSchemaVersion))
        catalog:assertHasPrivateWriteAccess("EditionDetailsMetadataDefinition.updateFromEarlierSchemaVersion")

        -- local photosToMigrate = catalog:findPhotosWithProperty(PluginInit.pluginID, 'catalogname')
        -- Retrieve photos that have been used already with the custom metadata.
        -- Optional:  can add property version number here.
        --[[
        for _, photo in ipairs(photosToMigrate) do
            local photoID = photo.localIdentifier
            logger.trace("photo was proceed: " .. tostring(photoID))
            -- ignore
        end
        ]]
        logger.trace("end updateFromEarlierSchemaVersion")
    end,

}

-------------------------------------------------------------------------------

return EditionDetailsMetadataDefinition
