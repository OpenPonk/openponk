Class {
	#name : #OPElementLayout,
	#superclass : #Object,
	#instVars : [
		'position',
		'extent',
		'path'
	],
	#classInstVars : [
		'none'
	],
	#category : #'OpenPonk-Core-Layout'
}

{ #category : #accessing }
OPElementLayout class >> neoJsonMapping: mapper [
	mapper
		for: self
		do: [ :mapping | 
			(mapping mapInstVar: #position) valueSchema: Point.
			(mapping mapInstVar: #extent) valueSchema: Point.
			(mapping mapInstVar: #path) valueSchema: OPRelationshipPath ]
]

{ #category : #'instance creation' }
OPElementLayout class >> none [
	^ none ifNil: [ none := self new ]
]

{ #category : #'instance creation' }
OPElementLayout class >> withPath: aRelationshipPath [
	^ self new
		path: aRelationshipPath;
		yourself
]

{ #category : #'instance creation' }
OPElementLayout class >> withPathFromSource: anId throughPoints: anArrayOfPoints [
	^ self
		withPath: (OPRelationshipPath fromSource: anId throughPoints: anArrayOfPoints)
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
	^ position isNil & extent isNil & path isNil
]

{ #category : #accessing }
OPElementLayout >> path [
	^ path
]

{ #category : #accessing }
OPElementLayout >> path: aRelationshipPath [
	path := aRelationshipPath
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
	position
		ifNil: [ path ifNil: [ ^ self ].
			aStream nextPutAll: ' (relationship)' ].
	aStream space.
	position printOn: aStream.
	extent
		ifNotNil: [ aStream space.
			extent printOn: aStream ]
]
