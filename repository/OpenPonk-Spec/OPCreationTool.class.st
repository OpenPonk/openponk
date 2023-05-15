"
A palette item used to create singular items in the view.
This class should not be used directly, use instead.
DCPalette>>newCreationTool:

"
Class {
	#name : #OPCreationTool,
	#superclass : #OPPaletteTool,
	#instVars : [
		'factory',
		'objectController',
		'feedback',
		'onComplete'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #protocol }
OPCreationTool >> deselect [

	feedback value: nil
]

{ #category : #accessing }
OPCreationTool >> factory: aBlock [
	factory := aBlock
]

{ #category : #callbacks }
OPCreationTool >> hoveredController: aController [
	feedback
		value:
			((aController canBeTargetFor: objectController)
				ifTrue: [ aController showAcceptFeedbackFor: objectController ]
				ifFalse: [ aController showDenyFeedbackFor: objectController ])
]

{ #category : #accessing }
OPCreationTool >> initialize [
	super initialize.
	onComplete := [ :ctrl |  ]
]

{ #category : #protocol }
OPCreationTool >> select [

	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal | 
		oldVal ifNotNil: [ oldVal remove ] ].
	objectController := factory value
]

{ #category : #callbacks }
OPCreationTool >> selectedControllers: aCollectionOfControllers [

	| targetController |
	aCollectionOfControllers size = 1 ifFalse: [ ^ self ].
	targetController := aCollectionOfControllers anyOne.
	(targetController canBeTargetFor: objectController) ifFalse: [ 
		^ self ].
	targetController addAsTargetFor: objectController.
	self palette selectSelectionTool.
	self palette selectedTool selectedControllers: { objectController }.
	onComplete value: objectController.
	objectController := nil
]

{ #category : #callbacks }
OPCreationTool >> whenCreated: aOneArgBlock [
	onComplete := aOneArgBlock
]
