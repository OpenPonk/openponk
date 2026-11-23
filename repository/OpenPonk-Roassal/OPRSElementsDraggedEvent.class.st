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

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> initialLineControlPoints: aDictionary [
	initialLineControlPoints := aDictionary
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> initialPositions [
	^ initialPositions
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> initialPositions: aDictionary [
	initialPositions := aDictionary
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> lines [
	^ lines ifNil: [ lines := #(  ) ]
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> lines: aCollection [
	lines := aCollection
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> shapes [
	^ shapes
]

{ #category : 'accessing' }
OPRSElementsDraggedEvent >> shapes: aCollection [
	shapes := aCollection
]
