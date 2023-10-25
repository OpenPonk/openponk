Class {
	#name : #OPRSConditionallyDraggable,
	#superclass : #RSDraggable,
	#instVars : [
		'conditionBlock'
	],
	#category : #'OpenPonk-Roassal-Interactions'
}

{ #category : #initialization }
OPRSConditionallyDraggable class >> onCondition: aBlock [

	^ self new
		  conditionBlock: aBlock;
		  yourself
]

{ #category : #initialization }
OPRSConditionallyDraggable >> conditionBlock: aBlock [

	conditionBlock := aBlock
]

{ #category : #initialization }
OPRSConditionallyDraggable >> initialize [

	super initialize.
	conditionBlock := [ true ]
]

{ #category : #events }
OPRSConditionallyDraggable >> processDrag: evt [

	conditionBlock value ifFalse: [ ^ self ].
	^ super processDrag: evt
]
