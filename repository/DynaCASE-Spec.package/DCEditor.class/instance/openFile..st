file support
openFile: aFileName
	| materializedDigram |
	aFileName isEmptyOrNil
		ifTrue: [ ^ self ].
	fileName := aFileName.
	materializedDigram := FLMaterializer materializeFromFileNamed: aFileName.
	self openDiagram: (materializedDigram at: #diagram).
	diagramController layout: (materializedDigram at: #layout)