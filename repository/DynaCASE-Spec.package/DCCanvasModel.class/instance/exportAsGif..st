exporting
exportAsGif: fileName
	self exportWith: [ :exporter | exporter asGIF ] toFile: fileName , '.gif'