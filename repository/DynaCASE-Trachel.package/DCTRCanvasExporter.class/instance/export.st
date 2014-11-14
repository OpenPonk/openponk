export
export
	canvas ifNil: [ self error: 'No canvas selected' ].
	fileName ifNil: [ self error: 'File name not set' ].
	self extent: self extent + (self cameraScale * oversize).
	self scaleToMorphLimits.
	imageExporter putForm: canvas morph imageForm onFileNamed: fileName
	
	"canvas morph ex
	| form |
	canvas ifNil: [ self error: 'No canvas selected' ].
	fileName ifNil: [ self error: 'File name not set' ].
	form := FormCanvas extent: canvas morph extent.
	canvas morph drawOn: form.
	canvas morph extent: canvas morph extent + (canvas camera scale * oversize).
	imageExporter putForm: (form contentsOfArea: canvas morph bounds) onFileNamed: fileName"