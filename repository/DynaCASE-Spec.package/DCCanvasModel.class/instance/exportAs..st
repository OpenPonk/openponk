exporting
exportAs: imageFormat
	"supported formats: PNG, JPEG, BMP, GIF	
	usage example:
 		self exportAs: #PNG
		self exportAs: 'PNG' "

	| exportCanvas |
	exportCanvas := roassalView canvas veryDeepCopy.
	exportCanvas fixedShapes do: [ :shape | shape remove ].
	exportCanvas camera
		focusOnCenter;
		scale: 1.0001.
	exportCanvas morph
		extent: exportCanvas encompassingRectangle extent + (20 @ 20);
		perform: ('exportAs' , imageFormat) asSymbol