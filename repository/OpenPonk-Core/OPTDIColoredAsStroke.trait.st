Trait {
	#name : #OPTDIColoredAsStroke,
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIColoredAsStroke >> color [

	^ self strokeColor
]

{ #category : #accessing }
OPTDIColoredAsStroke >> color: aColor [

	^ self strokeColor: aColor
]

{ #category : #accessing }
OPTDIColoredAsStroke >> strokeColor [

	(self isRendered and: [ self roassalShape isSelected ]) ifTrue: [
		^ self roassalShape color ].
	^ self stylePropertyNamed: #strokeColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTDIColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]

{ #category : #update }
OPTDIColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self roassalShape color: self strokeColor.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]
