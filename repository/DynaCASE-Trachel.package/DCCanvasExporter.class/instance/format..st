settings
format: imageFormat
	"supported formats: png, jpg, jpeg, bmp, gif	
	usage examples:
		format: 'png'
 		format: #png"

	| imageFormatUC |
	format := imageFormat.
	imageFormatUC := imageFormat asUppercase.
	(imageFormatUC = #JPEG or: imageFormatUC = #JPG)
		ifTrue: [ imageExporter := PluginBasedJPEGReadWriter ]
		ifFalse: [ imageExporter := Smalltalk at: (imageFormatUC , 'ReadWriter') asSymbol ]