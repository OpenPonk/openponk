private
loadElementsFromController
	self deprecated: 'Control reloading from Controller, not Canvas'.
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	diagramController rebuild.
	diagramController applyDefaultLayout ]
		ensure: [ World activeHand showTemporaryCursor: nil ]