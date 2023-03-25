Trait {
	#name : #OPTDIColoredAsFill,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIColoredAsFill >> color [

	^ self fillColor
]

{ #category : #accessing }
OPTDIColoredAsFill >> color: aColor [

	^ self fillColor: aColor
]

{ #category : #accessing }
OPTDIColoredAsFill >> fillColor [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color white ]
]

{ #category : #accessing }
OPTDIColoredAsFill >> fillColor: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #accessing }
OPTDIColoredAsFill >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self roassalShape color: self fillColor.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
