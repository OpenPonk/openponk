Extension { #name : #RTElement }

{ #category : #'*OpenPonk-Roassal2' }
RTElement >> withViewDo: aOneArgBlock [
	self view
		ifNil:
			[ self addCallback: (TRAddedCallback block: [ :evt | aOneArgBlock cull: self view ]) ]
		ifNotNil: [ aOneArgBlock cull: self view ]
]
