exporting
exportAsJpg: fileName
	self exportWith: [ :exporter | exporter asJPG ] toFile: fileName , '.jpg'