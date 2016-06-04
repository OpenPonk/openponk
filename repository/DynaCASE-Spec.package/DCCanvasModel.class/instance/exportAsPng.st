toolbar
exportAsPng
	FDSaveFileDialog new
		whenSelected: [ :file | self exportCanvasTo: file ];
		filteredExtensions: {'Images' -> #(png)};
		defaultName: self editor diagramController model name asFileName , '.png';
		open