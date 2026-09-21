"
Event announced on RSCanvas when user completes a drag gesture moving one or more shapes and connected edge control points.
"
Class {
	#name : 'OPRSElementsDraggedEvent',
	#superclass : 'RSAbstractMouseEvent',
	#instVars : [
		'shapes',
		'initialPositions',
		'lines',
		'initialLineControlPoints',
		'initialAnchors'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'testing' }
OPRSElementsDraggedEvent >> hasInitialAnchorFor: aShape [
	^ self initialAnchors includesKey: aShape
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> initialAnchorFor: aShape [
	^ self initialAnchors at: aShape
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> initialAnchors [
	^ initialAnchors ifNil: [ initialAnchors := Dictionary new ]
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> initialAnchors: aDictionary [
	initialAnchors := aDictionary
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> initialLineControlPoints [
	^ initialLineControlPoints ifNil: [ initialLineControlPoints := Dictionary new ]
]

{ #category : 'as yet unclassified' }
OPRSElementsDraggedEvent >> initialLineControlPoints: aDictionary [
	initialLineControlPoints := aDictionary
]

{ #category : 'as yet unclassified' }
OPRSElementsDraggedEvent >> initialPositions [
	^ initialPositions
]

{ #category : 'as yet unclassified' }
OPRSElementsDraggedEvent >> initialPositions: aDictionary [
	initialPositions := aDictionary
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> lines [
	^ lines ifNil: [ lines := #(  ) ]
]

{ #category : 'as yet unclassified' }
OPRSElementsDraggedEvent >> lines: aCollection [
	lines := aCollection
]

{ #category : 'as yet unclassified' }
OPRSElementsDraggedEvent >> shapes [
	^ shapes
]

{ #category : 'as yet unclassified' }
OPRSElementsDraggedEvent >> shapes: aCollection [
	shapes := aCollection
]
