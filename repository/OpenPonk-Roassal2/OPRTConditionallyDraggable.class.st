Class {
	#name : #OPRTConditionallyDraggable,
	#superclass : #RTAbstractDraggable,
	#instVars : [
		'conditionBlock'
	],
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #initialization }
OPRTConditionallyDraggable class >> initializeElement: element onCondition: aBlock [

	^ self new
		  conditionBlock: aBlock;
		  initializeElement: element;
		  yourself
]

{ #category : #initialization }
OPRTConditionallyDraggable class >> onCondition: aBlock [

	^ self new
		  conditionBlock: aBlock;
		  yourself
]

{ #category : #initialization }
OPRTConditionallyDraggable >> conditionBlock: aBlock [

	conditionBlock := aBlock
]

{ #category : #initialization }
OPRTConditionallyDraggable >> initialize [

	super initialize.
	conditionBlock := [ true ]
]

{ #category : #initialization }
OPRTConditionallyDraggable >> initializeElement: element onCondition: aBlock [

	self
		conditionBlock: aBlock;
		initializeElement: element
]

{ #category : #hooks }
OPRTConditionallyDraggable >> transformDistance: distanceAsPoint forElement: anElement [

	"Nothing to be transformed since there is no restriction here"

	conditionBlock value
		ifTrue: [ ^ distanceAsPoint ]
		ifFalse: [ ^ 0 @ 0 ]
]
