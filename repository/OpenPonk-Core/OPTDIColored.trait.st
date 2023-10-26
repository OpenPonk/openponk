Trait {
	#name : #OPTDIColored,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIColored >> color [

	^ self shouldBeImplemented
]

{ #category : #update }
OPTDIColored >> updateColorFromStyles [

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

{ #category : #update }
OPTDIColored >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
