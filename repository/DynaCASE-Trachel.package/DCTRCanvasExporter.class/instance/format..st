settings
format: imageFormat
	"supported formats: png, jpg, jpeg, bmp, gif	
	usage examples:
		format: 'png'
 		format: #png"

	| imageFormatUC |
	format := imageFormat.
	imageFormatUC := imageFormat asUppercase.
	imageExporter := (imageFormatUC = #JPEG or: imageFormatUC = #JPG)
		ifTrue: [ PluginBasedJPEGReadWriter ]
		ifFalse: [ Smalltalk at: (imageFormatUC , 'ReadWriter') asSymbol ]