return {

	LrSdkVersion = 3.0,
	LrSdkMinimumVersion = 2.0,
	LrToolkitIdentifier = 'at.homebrew.lrprintedition',

	LrPluginName = LOC "$$$/LRPrintEdition/Metadata/CusLabel=Print Edition",

	-- Add the Metadata Definition File
	LrMetadataProvider = 'PrintEditionMetadataDefinition.lua',
	
	-- Add the Metadata Tagset File
	LrMetadataTagsetFactory = {
		'PrintEditionMetadataTagset.lua',
	},
	LrLibraryMenuItems = {
--[[
		{
			title = LOC "$$$/LRPrintEdition/Menu/Library/SetLRPhotoID=Set LR Photo ID",
			file = "SetPhotoSource.lua",
			enabledWhen = "photosSelected",
		},
]]
		{
			title = LOC "$$$/LRPrintEdition/Menu/Library/SetLRPCatalogName=Set Catalog Name",
			file = "SetPhotoCatalog.lua",
			enabledWhen = "photosSelected",
		},
	},

	LrInitPlugin = "InitPlugin.lua",

	VERSION = { major=1, minor=0, revision=0, build=0, },

}
