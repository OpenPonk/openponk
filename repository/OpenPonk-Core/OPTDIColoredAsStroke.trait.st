Trait {
	#name : #OPTDIColoredAsStroke,
	#traits : 'OPTDIColored',
	#classTraits : 'OPTDIColored classTrait',
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #update }
OPTDIColoredAsStroke >> color [

	^ self strokeColor
]

{ #category : #accessing }
OPTDIColoredAsStroke >> strokeColor [

	^ self stylePropertyNamed: #strokeColor ifAbsent: [ Color black ]
]

{ #category : #accessing }
OPTDIColoredAsStroke >> strokeColor: aColor [

	^ self stylePropertyNamed: #strokeColor put: aColor
]
