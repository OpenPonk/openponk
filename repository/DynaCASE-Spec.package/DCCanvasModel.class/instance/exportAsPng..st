toolbar
exportAsPng: fileName
	(DCExportDiagramCommand on: roassalView canvas)
		asPng;
		fileName: fileName , '.png';
		execute