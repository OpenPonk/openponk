exporting
exportAs: imageFormat
	"supported formats: PNG, JPEG, BMP, GIF	
	usage example:
 		self exportAs: #PNG
		self exportAs: 'PNG' "

	roassalView canvas fixedShapes do: [ :shape | shape remove ].
	roassalView canvas morph perform: ('exportAs' , imageFormat) asSymbol.
	self createCanvasMenu