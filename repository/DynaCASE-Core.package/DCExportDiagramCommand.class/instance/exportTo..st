private
exportTo: aFileName
	exporter
		canvas: self canvas;
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		fileName: aFileName;
		export