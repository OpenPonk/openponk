toolbar
exportAsPng
	(DCExportDiagramCommand on: roassalView canvas)
		asPng;
		fileName: self editor diagramController model name , '.png';
		execute