Extension { #name : #WorldMorph }

{ #category : #'*OpenPonk-Morphic' }
WorldMorph >> showWaitCursorWhile: aBlock [

	[ 
	self currentWorld activeHand showTemporaryCursor: Cursor wait.
	self currentWorld doOneCycle.
	aBlock value ] ensure: [ 
		self currentWorld activeHand showTemporaryCursor: nil ]
]
