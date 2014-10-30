menu commands
openCommand: anObject
	(anObject isKindOf: DCDiagram)
		ifTrue: [ self workbench openEditorOn: anObject ]