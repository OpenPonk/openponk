private
exportWith: settings toFile: defaultName
	| exporter fileName |
	fileName := (UIManager default request: 'Please enter file name' initialAnswer: defaultName) ifNil: [ ^ nil ].
	exporter := (TRCanvasExporter canvas: roassalView canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20.
	settings value: exporter.
	exporter
		fileName: fileName;
		export