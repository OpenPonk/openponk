exporting
exportAsBmp: fileName
	self exportWith: [ :exporter | exporter asBMP ] toFile: fileName , '.bmp'