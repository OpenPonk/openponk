Trait {
	#name : 'OPTBorderColoredAsStroke',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPTBorderColoredAsStroke >> borderColor [

	^ self strokeColor
]

{ #category : 'accessing' }
OPTBorderColoredAsStroke >> defaultStrokeColor [

	^ Color black
]

{ #category : 'accessing' }
OPTBorderColoredAsStroke >> strokeColor [

	^ self
		  stylePropertyNamed: #strokeColor
		  ifAbsent: [ self defaultStrokeColor ]
]

{ #category : 'accessing' }
OPTBorderColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]

{ #category : 'initialization' }
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
	self updateRoassalShapeBorderColorFromStyles
]

{ #category : 'accessing' }
OPTBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateBorderColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]

{ #category : 'initialization' }
OPTBorderColoredAsStroke >> updateRoassalShapeBorderColorFromStyles [

	self roassalShape borderColor: self borderColor
]
