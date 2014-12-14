menu commands
openCommand: aDiagram
	self assert: (aDiagram isKindOf: DCDiagram).
	self workbench openEditorOn: aDiagram