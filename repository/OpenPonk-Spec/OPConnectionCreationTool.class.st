"
A palette item used to create connections between two existing items.
This class should not be used directly, use instead
DCPalette>>newConnectionCreationTool:

"
Class {
	#name : #OPConnectionCreationTool,
	#superclass : #OPPaletteTool,
	#instVars : [
		'connectionController',
		'factory',
		'feedback',
		'connectionFeedback',
		'onComplete'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #protocol }
OPConnectionCreationTool >> deselect [
	feedback value: nil.
	connectionFeedback
		ifNotNil: [ 
			connectionFeedback remove.
			connectionFeedback := nil ]
]

{ #category : #accessing }
OPConnectionCreationTool >> factory: aBlock [
	factory := aBlock
]

{ #category : #'as yet unclassified' }
OPConnectionCreationTool >> initialize [
	super initialize.
	onComplete := [ :ctrl | ]
]

{ #category : #protocol }
OPConnectionCreationTool >> select [
	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal | oldVal ifNotNil: [ oldVal remove ] ].
	connectionController := factory value.
	self selectSource
]

{ #category : #protocol }
OPConnectionCreationTool >> selectSource [
	self diagramController whenHoverChanged: [ :ctrl | self sourceEntered: ctrl ].
	self diagramController whenSelectionChanged: [ :ctrl | self sourceSelected: ctrl ]
]

{ #category : #protocol }
OPConnectionCreationTool >> selectTarget [
	self diagramController whenHoverChanged: [ :ctrl | self targetEntered: ctrl ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]
]

{ #category : #callbacks }
OPConnectionCreationTool >> sourceEntered: aController [
	feedback
		value:
			((aController canBeSourceFor: connectionController)
				ifTrue: [ aController showAcceptFeedbackFor: connectionController ]
				ifFalse: [ aController showDenyFeedbackFor: connectionController ])
]

{ #category : #callbacks }
OPConnectionCreationTool >> sourceSelected: aController [
	(aController canBeSourceFor: connectionController)
		ifFalse: [ ^ self ].
	aController addAsSourceFor: connectionController.
	connectionFeedback := connectionController connectionFeedback.
	connectionFeedback renderIn: aController figure view.
	self selectTarget
]

{ #category : #callbacks }
OPConnectionCreationTool >> targetEntered: aController [
	feedback
		value:
			((aController canBeTargetFor: connectionController)
				ifTrue: [ aController showAcceptFeedbackFor: connectionController ]
				ifFalse: [ aController showDenyFeedbackFor: connectionController ])
]

{ #category : #callbacks }
OPConnectionCreationTool >> targetSelected: aController [
	(aController canBeTargetFor: connectionController)
		ifFalse: [ ^ self ].
	aController addAsTargetFor: connectionController.
	self palette deselectTool.
	self palette selectedTool targetSelected: connectionController.
	onComplete value: connectionController.
	connectionController := nil.
	self deselect
]

{ #category : #'as yet unclassified' }
OPConnectionCreationTool >> whenCompleted: aOneArgBlock [
	onComplete := aOneArgBlock
]
