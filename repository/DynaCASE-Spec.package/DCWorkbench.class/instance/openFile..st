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
			self assert: (materializedProject at: #version) = '1.1'.
			self openProject: (materializedProject at: #project) ]