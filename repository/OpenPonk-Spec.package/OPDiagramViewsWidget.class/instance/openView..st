actions
openView: aView
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	self workbench openEditorOn: aView model ]
		ensure: [ World activeHand showTemporaryCursor: nil ]