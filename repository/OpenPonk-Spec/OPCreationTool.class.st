"
Palette tool specifically designed for creating new diagram nodes or entities on the canvas. 
Manages the mouse interaction and placement of the new element.
"
Class {
	#name : 'OPCreationTool',
	#superclass : 'OPPaletteTool',
	#instVars : [
		'factory',
		'objectController',
		'feedback',
		'onComplete'
	],
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'protocol' }
OPCreationTool >> deselect [

	feedback value: nil
]

{ #category : 'accessing' }
OPCreationTool >> factory: aBlock [
	factory := aBlock
]

{ #category : 'hooks' }
OPCreationTool >> hoveredController: aController [

	feedback value: ((aController canBeTargetFor: objectController)
			 ifTrue: [ aController showAcceptFeedbackFor: objectController ]
			 ifFalse: [ aController showDenyFeedbackFor: objectController ])
]

{ #category : 'initialization' }
OPCreationTool >> initialize [
	super initialize.
	onComplete := [ :ctrl |  ]
]

{ #category : 'protocol' }
OPCreationTool >> select [

	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal |
		oldVal ifNotNil: [ oldVal remove ] ].
	objectController := factory value
]

{ #category : 'hooks' }
OPCreationTool >> selectedControllers: aCollectionOfControllers [

	| targetController |
	aCollectionOfControllers size = 1 ifFalse: [ ^ self ].
	targetController := aCollectionOfControllers anyOne.
	(targetController canBeTargetFor: objectController) ifFalse: [
		^ self ].
	targetController addAsTargetFor: objectController.
	self palette selectSelectionTool.
	objectController roassalShape
		propertyAt: OPRSSelectable
		ifPresent: [ :selectable |
		selectable fakeClicked: objectController roassalShape ].
	onComplete value: objectController.
	objectController := nil
]

{ #category : 'callbacks' }
OPCreationTool >> whenCreated: aOneArgBlock [
	onComplete := aOneArgBlock
]
