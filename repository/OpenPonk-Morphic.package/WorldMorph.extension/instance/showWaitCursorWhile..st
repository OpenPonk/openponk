*OpenPonk-Morphic
showWaitCursorWhile: aBlock
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	aBlock value ]
		ensure: [ World activeHand showTemporaryCursor: nil ]