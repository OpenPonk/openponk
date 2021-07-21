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

{ #category : #accessing }
OPCreationTool >> initialize [
	super initialize.
	onComplete := [ :ctrl |  ]
]

{ #category : #protocol }
OPCreationTool >> select [
	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal | oldVal ifNotNil: [ oldVal remove ] ].
	objectController := factory value.
	self diagramController whenHoverChanged: [ :ctrl | self targetEntered: ctrl ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]
]

{ #category : #callbacks }
OPCreationTool >> targetEntered: aController [
	feedback
		value:
			((aController canBeTargetFor: objectController)
				ifTrue: [ aController showAcceptFeedbackFor: objectController ]
				ifFalse: [ aController showDenyFeedbackFor: objectController ])
]

{ #category : #callbacks }
OPCreationTool >> targetSelected: aController [
	(aController canBeTargetFor: objectController)
		ifFalse: [ ^ self ].
	aController addAsTargetFor: objectController.
	self palette deselectTool.
	self palette selectedTool targetSelected: objectController.
	onComplete value: objectController.
	objectController := nil
]

{ #category : #callbacks }
OPCreationTool >> whenCompleted: aOneArgBlock [
	onComplete := aOneArgBlock
]
