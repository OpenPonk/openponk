saving
saveDiagram: aMemento to: aFolder
	aMemento diagram ifNil: [ ^ self ].
	(aFolder / 'diagram' , self diagramExtension)
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (self serializeDiagram: aMemento diagram) ]
	"stream wantsLineEndConversion: true.
			stream lineEndConvention: #lf."