exporting
exportAs: imageFormat
	"supported formats: png, jpg, jpeg, bmp, gif	
	usage examples:
		self exportAs: 'png'
 		self exportAs: #png"

	(DCTRCanvasExporter canvas: roassalView canvas)
		withoutFixedShapes;
		whole;
		centered;
		defaultScale;
		oversizedBy: 20 @ 20;
		format: imageFormat;
		fileName: [ 
					(UIManager default request: 'Please enter file name' initialAnswer: self workbench title , '.' , imageFormat)
						ifNil: [ ^ nil ] ];
		export