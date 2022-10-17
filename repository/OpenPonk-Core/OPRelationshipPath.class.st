Class {
	#name : #OPRelationshipPath,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'source',
		'points'
	],
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #'instance creation' }
OPRelationshipPath class >> fromSource: anId throughPoints: anArrayOfPoints [
	^ self new
		points: anArrayOfPoints;
		source: anId;
		yourself
]

{ #category : #accessing }
OPRelationshipPath class >> neoJsonMapping: mapper [
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

{ #category : #comparing }
OPRelationshipPath >> < aComparable [

	"Answer whether the receiver is less than the argument."

	^ self source < aComparable source or: [ 
		  self source = aComparable source and: [ 
			  self points < aComparable points ] ]
]

{ #category : #comparing }
OPRelationshipPath >> = aComparable [

	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ self source = aComparable source and: [ 
		  self points = aComparable points ]
]

{ #category : #comparing }
OPRelationshipPath >> hash [

	"Hash must be redefined whenever = is redefined."

	(self points isNil or: [ self points size < 2 ]) ifTrue: [ 
		^ self source hash ].
	^ self source hash bitXor: self points second hash
]

{ #category : #accessing }
OPRelationshipPath >> points [
	^ points
]

{ #category : #accessing }
OPRelationshipPath >> points: anArrayOfPoints [
	points := anArrayOfPoints
]

{ #category : #accessing }
OPRelationshipPath >> source [
	^ source
]

{ #category : #accessing }
OPRelationshipPath >> source: anId [
	source := anId
]
