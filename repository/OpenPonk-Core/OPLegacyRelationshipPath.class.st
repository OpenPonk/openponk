Class {
	#name : 'OPLegacyRelationshipPath',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'source',
		'points'
	],
	#category : 'OpenPonk-Core-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'Diagrams'
}

{ #category : 'instance creation' }
OPLegacyRelationshipPath class >> fromSource: anId throughPoints: anArrayOfPoints [
	^ self new
		points: anArrayOfPoints;
		source: anId;
		yourself
]

{ #category : 'testing' }
OPLegacyRelationshipPath class >> isDeprecated [
	"no longer tested and used"

	^ true
]

{ #category : 'accessing' }
OPLegacyRelationshipPath class >> neoJsonMapping: mapper [
	mapper
		for: self
			do: [ :mapping | 
			(mapping mapInstVar: #points) valueSchema: #ArrayOfPoints.
			(mapping mapInstVar: #source) valueSchema: UUID ];
		for: UUID
			customDo: [ :mapping | 
			mapping
				encoder: [ :uuid | uuid asString ];
				decoder: [ :string | 
					[ UUID fromString: string ]
						on: Error
						do: [ string ] ] ];
		for: #ArrayOfPoints
			customDo: [ :mapping | mapping listOfElementSchema: Point ];
		mapAllInstVarsFor: Point
]

{ #category : 'comparing' }
OPLegacyRelationshipPath >> < aComparable [

	"Answer whether the receiver is less than the argument."

	^ self source < aComparable source or: [ 
		  self source = aComparable source and: [ 
			  self points < aComparable points ] ]
]

{ #category : 'comparing' }
OPLegacyRelationshipPath >> = aComparable [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self source = aComparable source and: [ 
		  self points = aComparable points ]
]

{ #category : 'comparing' }
OPLegacyRelationshipPath >> hash [

	"Hash must be redefined whenever = is redefined."

	(self points isNil or: [ self points size < 2 ]) ifTrue: [ 
		^ self source hash ].
	^ self source hash bitXor: self points second hash
]

{ #category : 'accessing' }
OPLegacyRelationshipPath >> points [
	^ points
]

{ #category : 'accessing' }
OPLegacyRelationshipPath >> points: anArrayOfPoints [
	points := anArrayOfPoints
]

{ #category : 'accessing' }
OPLegacyRelationshipPath >> source [
	^ source
]

{ #category : 'accessing' }
OPLegacyRelationshipPath >> source: anId [
	source := anId
]
