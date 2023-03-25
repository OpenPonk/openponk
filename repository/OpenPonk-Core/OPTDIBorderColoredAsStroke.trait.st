Trait {
	#name : #OPTDIBorderColoredAsStroke,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> strokeColor [

	(self isRendered and: [ self roassalShape isSelected ]) ifTrue: [
		^ self roassalShape borderColor ].
	^ self stylePropertyNamed: #strokeColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]

{ #category : #accessing }
OPTDIBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self roassalShape borderColor: self strokeColor.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
