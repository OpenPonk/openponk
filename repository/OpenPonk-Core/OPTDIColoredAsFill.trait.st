Trait {
	#name : #OPTDIColoredAsFill,
	#traits : 'OPTDIColored',
	#classTraits : 'OPTDIColored classTrait',
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #accessing }
OPTDIColoredAsFill >> color [

	^ self fillColor
]

{ #category : #accessing }
OPTDIColoredAsFill >> fillColor [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color white ]
]

{ #category : #accessing }
OPTDIColoredAsFill >> fillColor: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]
