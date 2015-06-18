toolbar
exportAsJpg: fileName
	(DCExportDiagramCommand on: roassalView canvas)
		asJpeg;
		fileName: fileName , '.jpg';
		execute