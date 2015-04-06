as yet unclassified
iconForDiagram: aDiagram
	| s |
	s := aDiagram className asSymbol.
	s = #BormDiagram
		ifTrue: [ ^ #BormEditorIcons asClass current diagram16Icon ].
	s = #DCFsm
		ifTrue: [ ^ Smalltalk ui icons dcFsmDiagramIcon ].
	s = #DCOmlDiagram
		ifTrue: [ ^ Smalltalk ui icons dcOmlDiagramIcon ].
	^ nil