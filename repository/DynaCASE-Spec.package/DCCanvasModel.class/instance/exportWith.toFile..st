private
exportWith: settings toFile: fileName
	| exporter |
	exporter := (TRCanvasExporter canvas: roassalView canvas)
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20.
	settings value: exporter.
	exporter
		fileName: fileName;
		export