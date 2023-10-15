Trait {
	#name : #OPTDIBorderColoredAsStroke,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> strokeColor [

	^ self stylePropertyNamed: #strokeColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self roassalShape
		propertyAt: OPRSSelectable
		ifPresent: [ :selectable |
			| key |
			key := selectable copyKey , 'color'.
			self roassalShape properties
				at: key
				ifPresent: [ :previousBorder |
					previousBorder color: self strokeColor.
					^ self ] ].
	self roassalShape borderColor: self strokeColor.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
