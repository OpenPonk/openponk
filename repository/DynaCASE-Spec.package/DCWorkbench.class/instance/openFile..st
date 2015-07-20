file support
openFile: aFileName
	| materialization serializer materializedProject |
	aFileName isEmptyOrNil
		ifTrue: [ ^ self ].
	aFileName asFileReference
		readStreamDo: [ :stream | 
			materialization := (STON reader
				allowComplexMapKeys: true;
				on: stream;
				yourself) next.
			serializer := DCSerializer new.
			materializedProject := serializer materializeProject: materialization.
			materializedProject fileName: aFileName.
			self openProject: materializedProject ]