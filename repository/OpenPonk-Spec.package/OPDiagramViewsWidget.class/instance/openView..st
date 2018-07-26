actions
openView: aView
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	self workbench openEditorOnView: aView ]
		ensure: [ World activeHand showTemporaryCursor: nil ]