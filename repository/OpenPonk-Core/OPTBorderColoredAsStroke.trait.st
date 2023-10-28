Trait {
	#name : #OPTBorderColoredAsStroke,
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #accessing }
OPTBorderColoredAsStroke >> borderColor [

	^ self strokeColor
]

{ #category : #accessing }
OPTBorderColoredAsStroke >> strokeColor [

	^ self stylePropertyNamed: #strokeColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTBorderColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]

{ #category : #update }
OPTBorderColoredAsStroke >> updateBorderColorFromStyles [

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
OPTBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateBorderColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
