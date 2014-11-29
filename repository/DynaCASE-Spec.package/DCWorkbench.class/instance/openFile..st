file support
openFile: aFileName
	| materialization serializer serializedProject |
	aFileName isEmptyOrNil
		ifTrue: [ ^ self ].
	aFileName asFileReference
		readStreamDo: [ :stream | 
			materialization := (STON reader
				allowComplexMapKeys: true;
				on: stream) next.
			serializer := DCSerializer new.
			serializedProject := serializer materializeProject: materialization.
			self openProject: serializedProject ]