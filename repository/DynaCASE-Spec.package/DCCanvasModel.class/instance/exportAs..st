exporting
exportAs: imageFormat
	"supported formats: png, jpg, jpeg, bmp, gif	
	usage examples:
		self exportAs: 'png'
 		self exportAs: #png"

	(TRCanvasExporter canvas: roassalView canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		perform: ('as' , imageFormat asUppercase) asSymbol;
		fileName:
				((UIManager default request: 'Please enter file name' initialAnswer: self workbench title , '.' , imageFormat)
						ifNil: [ ^ nil ]);
		export