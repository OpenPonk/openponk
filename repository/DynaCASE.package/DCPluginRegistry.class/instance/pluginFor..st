accessing
pluginFor: aDiagram
	(aDiagram isKindOf: DCDiagram)
		ifTrue: [ ^ self pluginForDiagram: aDiagram ].
	self error: 'Unable to retrieve plugin for ' , aDiagram printString