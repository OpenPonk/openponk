Class {
	#name : 'OPLegacyElementLayout',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'position',
		'extent',
		'path'
	],
	#classInstVars : [
		'none'
	],
	#category : 'OpenPonk-Core-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'LegacySupport-Diagrams'
}

{ #category : 'testing' }
OPLegacyElementLayout class >> isDeprecated [
	"no longer tested and used"

	^ true
]

{ #category : 'accessing' }
OPLegacyElementLayout class >> neoJsonMapping: mapper [
	mapper
		for: self
			do: [ :mapping | 
			(mapping mapInstVar: #position) valueSchema: Point.
			(mapping mapInstVar: #extent) valueSchema: Point.
			(mapping mapInstVar: #path) valueSchema: OPLegacyRelationshipPath ];
		mapAllInstVarsFor: Point
]

{ #category : 'instance creation' }
OPLegacyElementLayout class >> none [
	^ none ifNil: [ none := self new ]
]

{ #category : 'instance creation' }
OPLegacyElementLayout class >> withPath: aRelationshipPath [
	^ self new
		path: aRelationshipPath;
		yourself
]

{ #category : 'instance creation' }
OPLegacyElementLayout class >> withPathFromSource: anId throughPoints: anArrayOfPoints [
	^ self
		withPath: (OPLegacyRelationshipPath fromSource: anId throughPoints: anArrayOfPoints)
]

{ #category : 'instance creation' }
OPLegacyElementLayout class >> withPosition: aPoint [
	^ self new
		position: aPoint;
		yourself
]

{ #category : 'instance creation' }
OPLegacyElementLayout class >> withPosition: aPoint extent: anExtentPoint [
	^ self new
		position: aPoint;
		extent: anExtentPoint;
		yourself
]

{ #category : 'comparing' }
OPLegacyElementLayout >> < anOtherLayout [

	^ (self position isNotNil and: [ anOtherLayout position isNil ]) or: [ 
		  self position isNil = anOtherLayout position isNil and: [ 
			  self path isNotNil and: [ anOtherLayout path isNil ] ] ]
]

{ #category : 'comparing' }
OPLegacyElementLayout >> = anOtherLayout [

	self position ifNil: [ ^ self path = anOtherLayout path ].
	^ position = anOtherLayout position and: [ 
		  extent = anOtherLayout extent ]
]

{ #category : 'converting' }
OPLegacyElementLayout >> applyToDiagramElement: aDiagramElement [

	position
		ifNil: [
			path ifNotNil: [
				aDiagramElement innerWaypoints:
					(path points copyFrom: 2 to: path points size - 1) ] ]
		ifNotNil: [
			aDiagramElement bounds: (OPNodeBounds
					 withPosition: position
					 extent: (extent ifNil: [ aDiagramElement roassalShape extent ])) ].
	aDiagramElement updateRenderFromSelf
]

{ #category : 'accessing' }
OPLegacyElementLayout >> extent [
	^ extent
]

{ #category : 'accessing' }
OPLegacyElementLayout >> extent: aPoint [ 
	extent := aPoint
]

{ #category : 'testing' }
OPLegacyElementLayout >> hasExtent [
	^ extent isNotNil
]

{ #category : 'comparing' }
OPLegacyElementLayout >> hash [

	self position ifNil: [ ^ self path hash ].
	^ position hash bitXor: extent hash
]

{ #category : 'testing' }
OPLegacyElementLayout >> isNone [
	^ position isNil & extent isNil & path isNil
]

{ #category : 'accessing' }
OPLegacyElementLayout >> path [
	^ path
]

{ #category : 'accessing' }
OPLegacyElementLayout >> path: aRelationshipPath [
	path := aRelationshipPath
]

{ #category : 'accessing' }
OPLegacyElementLayout >> position [
	^ position
]

{ #category : 'accessing' }
OPLegacyElementLayout >> position: aPoint [ 
	position := aPoint
]

{ #category : 'printing' }
OPLegacyElementLayout >> printOn: aStream [
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
