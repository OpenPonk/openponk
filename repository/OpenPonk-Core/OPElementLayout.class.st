Class {
	#name : #OPElementLayout,
	#superclass : #Object,
	#instVars : [
		'position',
		'extent'
	],
	#classInstVars : [
		'none'
	],
	#category : #'OpenPonk-Core-Figures'
}

{ #category : #accessing }
OPElementLayout class >> neoJsonMapping: mapper [
	mapper
		for: self
			customDo: [ :mapping | 
			mapping
				reader: [ :jsonReader | 
					| elementLayout map |
					elementLayout := self new.
					map := jsonReader parseMap.
					((map includesKey: #x) and: [ map includesKey: #y ])
						ifTrue: [ elementLayout position: (map at: #x) @ (map at: #y) ]
						ifFalse: [ (map includesKey: #position)
								ifTrue: [ elementLayout
										position: ((map at: #position) at: #x) @ ((map at: #position) at: #y) ].
							(map includesKey: #extent)
								ifTrue: [ elementLayout
										extent: ((map at: #extent) at: #x) @ ((map at: #extent) at: #y) ] ].
					elementLayout ];
				writer: [ :jsonWriter :aLayout | 
					jsonWriter
						writeMapStreamingDo: [ :mapWriter | 
							mapWriter writeKey: #position value: aLayout position as: Point.
							aLayout extent
								ifNotNil: [ mapWriter writeKey: #extent value: aLayout extent as: Point ] ] ] ];
		mapInstVarsFor: Point
]

{ #category : #'instance creation' }
OPElementLayout class >> none [
	^ none ifNil: [ none := self new ]
]

{ #category : #'instance creation' }
OPElementLayout class >> withPosition: aPoint [
	^ self new
		position: aPoint;
		yourself
]

{ #category : #'instance creation' }
OPElementLayout class >> withPosition: aPoint extent: anExtentPoint [
	^ self new
		position: aPoint;
		extent: anExtentPoint;
		yourself
]

{ #category : #comparing }
OPElementLayout >> = anOtherLayout [
	^ position = anOtherLayout position
		and: [ extent = anOtherLayout extent ]
]

{ #category : #accessing }
OPElementLayout >> extent [
	^ extent
]

{ #category : #accessing }
OPElementLayout >> extent: aPoint [ 
	extent := aPoint
]

{ #category : #testing }
OPElementLayout >> hasExtent [
	^ extent isNotNil
]

{ #category : #comparing }
OPElementLayout >> hash [
	^ position hash bitXor: extent hash
]

{ #category : #testing }
OPElementLayout >> isNone [
	^ position isNil & extent isNil
]

{ #category : #accessing }
OPElementLayout >> position [
	^ position
]

{ #category : #accessing }
OPElementLayout >> position: aPoint [ 
	position := aPoint
]

{ #category : #printing }
OPElementLayout >> printOn: aStream [
	super printOn: aStream.
	position ifNil: [ ^ self ].
	aStream space.
	position printOn: aStream.
	extent
		ifNotNil: [ aStream space.
			extent printOn: aStream ]
]
