export
export
	canvas ifNil: [ self error: 'No canvas selected' ].
	fileName ifNil: [ self error: 'File name not set' ].
	canvas morph extent: canvas morph extent + (canvas camera scale * oversize).
	imageExporter putForm: canvas morph imageForm onFileNamed: fileName