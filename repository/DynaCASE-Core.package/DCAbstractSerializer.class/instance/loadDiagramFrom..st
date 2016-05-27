loading
loadDiagramFrom: aFolder
	(aFolder / 'diagram' , self diagramExtension) exists
		ifFalse: [ ^ nil ].
	^ self materializeDiagramFrom: (aFolder / 'diagram' , self diagramExtension) contents