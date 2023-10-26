Trait {
	#name : #OPTDIBorderColoredAsStroke,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> borderColor [

	^ self strokeColor
]

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> strokeColor [

	^ self stylePropertyNamed: #strokeColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]

{ #category : #update }
OPTDIBorderColoredAsStroke >> updateBorderColorFromStyles [

	self roassalShape
		propertyAt: OPRSSelectable
		ifPresent: [ :selectable |
			| key |
			key := selectable copyKey , 'border'.
			self roassalShape properties
				at: key
				ifPresent: [ :previousBorder |
					previousBorder do: [ :each | each color: self borderColor ].
					^ self ] ].
	self roassalShape borderColor: self borderColor
]

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateBorderColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
