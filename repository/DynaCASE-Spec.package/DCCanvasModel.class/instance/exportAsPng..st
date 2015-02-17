exporting
exportAsPng: fileName
	self exportWith: [ :exporter | exporter asPNG ] toFile: fileName , '.png'