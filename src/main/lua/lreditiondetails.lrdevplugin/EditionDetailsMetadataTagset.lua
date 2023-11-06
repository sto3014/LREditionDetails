return{

	title = LOC "$$$/LRPrintEdition/Metadata/Tagset/Title=Print Edition",
	id = 'LRPrintEditionTagset',
	
	items = {
		{ 'com.adobe.label', label = LOC "$$$/LRPrintEdition/Metadata/OrigLabel=Standard Metadata" },
		'com.adobe.filename',
		'com.adobe.folder',
		
		'com.adobe.separator',
		
		'com.adobe.title',
		{ 'com.adobe.caption', height_in_lines = 3 },

		'com.adobe.copyname',

		'com.adobe.separator',

		{ "com.adobe.copyrightState", pruneRedundantFields = false },

		"com.adobe.copyright",

		"com.adobe.source",

		'com.adobe.separator',
		{
			formatter = "com.adobe.label",
			label = LOC "$$$/LRPrintEdition/Metadata/Tagset/Title=Print Edition",
		},

		'at.homebrew.lrprintedition.catalogtype',

		'at.homebrew.lrprintedition.catalogname',

		'at.homebrew.lrprintedition.lotno',

		'at.homebrew.lrprintedition.copy',

		'at.homebrew.lrprintedition.edition',

		'at.homebrew.lrprintedition.mark',

		{'at.homebrew.lrprintedition.comment',height_in_lines = 3 },

		"com.adobe.separator",
		{
			formatter = "com.adobe.label",
			label = LOC "$$$/LRPrintEdition/Metadata/ExifLabel=EXIF",
		},

		"com.adobe.imageFileDimensions",		-- dimensions
		"com.adobe.imageCroppedDimensions",

		"com.adobe.exposure",					-- exposure factors
		"com.adobe.brightnessValue",
		"com.adobe.exposureBiasValue",
		"com.adobe.flash",
		"com.adobe.exposureProgram",
		"com.adobe.meteringMode",
		"com.adobe.ISOSpeedRating",

		"com.adobe.focalLength",				-- lens info
		"com.adobe.focalLength35mm",
		"com.adobe.lens",
		"com.adobe.subjectDistance",

		"com.adobe.dateTimeOriginal",
		"com.adobe.dateTimeDigitized",
		"com.adobe.dateTime",

		"com.adobe.make",						-- camera
		"com.adobe.model",
		"com.adobe.serialNumber",

		"com.adobe.userComment",

		"com.adobe.artist",
		"com.adobe.software",

		"com.adobe.GPS",						-- gps
		"com.adobe.GPSAltitude",
		"com.adobe.GPSImgDirection",

	},
}
