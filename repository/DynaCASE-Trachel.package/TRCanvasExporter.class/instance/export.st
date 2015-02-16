export
export
	"Makes the export itself.
Due to applying oversize and scaling to morph limits it is recommended to use only once for single instance."

	canvas ifNil: [ self error: 'No canvas selected' ].
	fileName ifNil: [ self error: 'File name not set' ].
	self
		applyOversize;
		scaleToMorphLimits.
	imageExporter putForm: canvas morph imageForm onFileNamed: fileName value