as yet unclassified
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
			serializedProject := serializer materializeProject: materialization ].
	self class addToRecent: aFileName named: serializedProject projectName.
	DCWorkbench openProject: serializedProject.
	self delete