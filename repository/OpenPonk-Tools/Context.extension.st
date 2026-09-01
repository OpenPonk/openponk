Extension { #name : 'Context' }

{ #category : '*OpenPonk-Tools' }
Context >> tempNames [

	self flag: 'Pharo 13- compatibility'.

	(self respondsTo: #temporaryVariableNames) ifTrue: [ ^ self temporaryVariableNames ].

	^ self astScope allTempNames
]
