file support
openFile: aFileName
	| materializedDigram |
	aFileName isEmptyOrNil
		ifTrue: [ ^ self ].
	fileName := aFileName.
	aFileName asFileReference
		readStreamDo: [ :stream | 
			materializedDigram := (STON reader
				allowComplexMapKeys: true;
				on: stream) next.
			self openDiagram: (materializedDigram at: #diagram).
			diagramController layout: (materializedDigram at: #layout) ]