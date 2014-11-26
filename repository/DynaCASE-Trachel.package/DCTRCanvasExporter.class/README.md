A DCTRCanvasExporter is exporter of canvas into image
	
	supported formats: png, jpg, jpeg, bmp, gif	
	usage example:

	(DCTRCanvasExporter canvas: aRTView canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		asPNG;
		fileName: ((UIManager default request: 'Please enter file name' initialAnswer: 'export.png') ifNil: [ ^ nil ]);
		export