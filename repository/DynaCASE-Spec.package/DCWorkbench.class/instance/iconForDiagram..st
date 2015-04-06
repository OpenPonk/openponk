as yet unclassified
iconForDiagram: aSymbol
	aSymbol = #BormDiagram
		ifTrue: [ ^ #BormEditorIcons asClass current diagram16Icon ].
	aSymbol = #DCFsm
		ifTrue: [ ^ Smalltalk ui icons dcFsmDiagramIcon ].
	aSymbol = #DCOmlDiagram
		ifTrue: [ ^ Smalltalk ui icons dcOmlDiagramIcon ].
	^ nil