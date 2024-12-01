return {

    LrSdkVersion = 3.0,
    LrSdkMinimumVersion = 2.0,
    LrToolkitIdentifier = 'at.homebrew.lreditiondetails',

    LrPluginName = LOC "$$$/LREditionDetails/Metadata/CusLabel=Edition Details",

    -- Add the Metadata Definition File
    LrMetadataProvider = 'EditionDetailsMetadataDefinition.lua',

    -- Add the Metadata Tagset File
    LrMetadataTagsetFactory = {
        'EditionDetailsMetadataTagset.lua',
    },
    LrLibraryMenuItems = {
        {
            title = LOC "$$$/LREditionDetails/Menu/Library/SetSource=Set source by photo ID",
            file = "SetPhotoSource.lua",
            enabledWhen = "anythingSelected",
        },
        {
            title = LOC "$$$/LREditionDetails/Menu/Library/SetLRPCatalogName=Initialize edition details",
            file = "SetPhotoCatalog.lua",
            enabledWhen = "photosSelected",
        },
        {
            title = LOC "$$$/LREditionDetails/Menu/Library/CreateQRCode=Create QR Code",
            file = "CreateQRCode.lua",
            enabledWhen = "photosSelected",
        },
    },

    LrInitPlugin = "InitPlugin.lua",

    VERSION = { major = 1, minor = 1, revision = 0, build = 0, },

}
