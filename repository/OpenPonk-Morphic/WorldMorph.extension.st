Extension { #name : #WorldMorph }

{ #category : #'*OpenPonk-Morphic' }
WorldMorph >> showWaitCursorWhile: aBlock [
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	aBlock value ]
		ensure: [ World activeHand showTemporaryCursor: nil ]
]
