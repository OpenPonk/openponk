"
Represents a legacy routing path consisting of a source and intermediate points for a diagram relationship.
Retained strictly for backward compatibility.
"
Class {
	#name : 'OPLegacyRelationshipPath',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'source',
		'points'
	],
	#category : 'OpenPonk-Core-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'LegacySupport-Diagrams'
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

	self source = aComparable source ifFalse: [ ^ self source < aComparable source ].
	self points withIndexDo: [ :eachPoint :index |
			| otherPoint |
			aComparable points size < index ifTrue: [ ^ false ].
			otherPoint := aComparable points at: index.
			eachPoint = otherPoint ifFalse: [
					^ eachPoint x = otherPoint x
						  ifTrue: [ eachPoint y < otherPoint y ]
						  ifFalse: [ eachPoint x < otherPoint x ] ] ].
	^ self points size < aComparable points size
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
