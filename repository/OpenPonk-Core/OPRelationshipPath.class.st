Class {
	#name : #OPRelationshipPath,
	#superclass : #Object,
	#instVars : [
		'source',
		'points'
	],
	#category : #'OpenPonk-Core-Layout'
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
		mapInstVarsFor: Point
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
