menu commands
openCommand: aDiagram
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	self workbench openEditorOn: aDiagram ]
		ensure: [ World activeHand showTemporaryCursor: nil ]