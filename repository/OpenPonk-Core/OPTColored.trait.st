Trait {
	#name : 'OPTColored',
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'accessing' }
OPTColored >> color [

	^ self shouldBeImplemented
]

{ #category : 'initialization' }
OPTColored >> updateColorFromStyles [

	self roassalShape
		propertyAt: OPRSSelectable
		ifPresent: [ :selectable |
			| key |
			key := selectable copyKey , 'color'.
			self roassalShape properties at: key ifPresent: [
				self roassalShape properties
					at: key
					put: (OrderedCollection with: self color).
				^ self ] ].
	self roassalShape color: self color
]

{ #category : 'initialization' }
OPTColored >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
