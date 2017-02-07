*OpenPonk-Roassal2
withViewDo: aOneArgBlock
	self view
		ifNil:
			[ self addCallback: (TRAddedCallback block: [ :evt | aOneArgBlock cull: self view ]) ]
		ifNotNil: [ aOneArgBlock cull: self view ]