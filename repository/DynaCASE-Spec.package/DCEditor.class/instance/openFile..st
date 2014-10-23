file support
openFile: aFileName
	| materializedProject |
	aFileName isEmptyOrNil
		ifTrue: [ ^ self ].
	aFileName asFileReference
		readStreamDo: [ :stream | 
			materializedProject := (STON reader
				allowComplexMapKeys: true;
				on: stream) next.
			self openProject: (materializedProject at: #project) ]