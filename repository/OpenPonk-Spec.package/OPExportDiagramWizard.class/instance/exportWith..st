exporting
exportWith: aDictionary
	| gridShape gridColor |
	(aDictionary at: #targetFile) ifNil: [ ^ self inform: 'Export canceled.' ].
	gridShape := view canvas shapes detect: [ :each | each isKindOf: TRCanvasGridShape ].
	gridColor := gridShape color.
	[ gridShape color: Color transparent.
	OPTRCanvasExporter new
		asPNG;
		canvas: view canvas;
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		fileName: (aDictionary at: #targetFile);
		export ]
		ensure: [ gridShape color: gridColor ]