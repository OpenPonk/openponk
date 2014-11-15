export
export
	canvas ifNil: [ self error: 'No canvas selected' ].
	fileName ifNil: [ self error: 'File name not set' ].
	self extent: self extent + (self cameraScale * oversize).
	self scaleToMorphLimits.
	imageExporter putForm: canvas morph imageForm onFileNamed: fileName