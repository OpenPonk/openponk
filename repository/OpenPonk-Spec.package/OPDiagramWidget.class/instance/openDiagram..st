actions
openDiagram: aModel
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	self workbench openEditorOn: aModel ]
		ensure: [ World activeHand showTemporaryCursor: nil ]