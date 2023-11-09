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
			title = LOC "$$$/LREditionDetails/Menu/Library/SetLRPCatalogName=Initialise Edition Details",
			file = "SetPhotoCatalog.lua",
			enabledWhen = "photosSelected",
		},
	},

	LrInitPlugin = "InitPlugin.lua",

	VERSION = { major=1, minor=0, revision=0, build=0, },

}
