toolbar
exportCanvasTo: aFile
	| gridShape gridColor |
	gridShape := roassalView canvas shapes
		detect: [ :each | each isKindOf: TRCanvasGridShape ].
	gridColor := gridShape color.
	[ gridShape color: Color transparent.
	OPTRCanvasExporter new
		asPNG;
		canvas: roassalView canvas;
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		fileName: aFile;
		export.
	self inform: 'Saved to ' , aFile pathString ]
		ensure: [ gridShape color: gridColor ]