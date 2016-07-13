toolbar
exportAsPng
	FDSaveFileDialog new
		whenSelected: [ :file | self exportCanvasTo: file ];
		extensionFilters: {'Images' -> #(png)};
		defaultName: self editor diagramController model name asFileName , '.png';
		open