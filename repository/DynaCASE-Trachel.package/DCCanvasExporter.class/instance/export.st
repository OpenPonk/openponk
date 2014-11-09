export
export
	fileName ifNil: [ self error: 'File name not set' ].
	imageExporter
		putForm:
			(canvas morph
				extent: canvas morph extent + oversize;
				yourself) imageForm
		onFileNamed: fileName