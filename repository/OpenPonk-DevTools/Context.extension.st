Extension { #name : 'Context' }

{ #category : '*OpenPonk-DevTools' }
Context >> tempNames [

	self flag: 'Pharo 13- compatibility'.

	(self respondsTo: #temporaryVariableNames) ifTrue: [ ^ self temporaryVariableNames ].

	^ self astScope allTempNames
]
