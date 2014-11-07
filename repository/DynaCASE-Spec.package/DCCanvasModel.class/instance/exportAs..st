exporting
exportAs: imageFormat
	"supported formats: png, jpg, jpeg, bmp, gif	
	usage example:
		self exportAs: 'png'
 		self exportAs: #png"

	| exportCanvas exporter fileName imageFormatUC |
	exportCanvas := roassalView canvas veryDeepCopy.
	exportCanvas fixedShapes do: [ :shape | shape remove ].
	exportCanvas camera
		doWithoutCallbacks: [ 
			exportCanvas camera
				focusOnCenter;
				scale: 1.0001 ].
	exportCanvas morph extent: exportCanvas encompassingRectangle extent + (20 @ 20).
	fileName := UIManager default
		request: 'Please enter file name' translated
		initialAnswer: self workbench title , '.' , imageFormat.
	imageFormatUC := imageFormat asUppercase.
	(imageFormatUC = #JPEG or: imageFormatUC = #JPG)
		ifTrue: [ exporter := PluginBasedJPEGReadWriter ]
		ifFalse: [ exporter := Smalltalk at: (imageFormatUC , 'ReadWriter') asSymbol ].
	exporter putForm: exportCanvas morph imageForm onFileNamed: fileName