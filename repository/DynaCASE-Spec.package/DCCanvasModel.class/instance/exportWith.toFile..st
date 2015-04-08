private
exportWith: settings toFile: defaultName
	| exporter fileName |
	fileName := (UIManager default request: 'Please enter file name' initialAnswer: defaultName) ifNil: [ ^ nil ].
	exporter := TRCanvasExporter canvas: roassalView canvas.
	settings value: exporter.
	exporter
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		fileName: fileName;
		export