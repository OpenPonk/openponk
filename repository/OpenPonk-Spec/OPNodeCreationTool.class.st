"
Palette tool specifically designed for creating new diagram nodes or entities on the canvas. 
Manages the mouse interaction and placement of the new element.
"
Class {
	#name : 'OPNodeCreationTool',
	#superclass : 'OPCreationTool',
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'hooks' }
OPNodeCreationTool >> hoveredController: aTargetController [

	feedback value: ((aTargetController canBeTargetFor: controller)
			 ifTrue: [ aTargetController showAcceptFeedbackFor: controller ]
			 ifFalse: [ aTargetController showDenyFeedbackFor: controller ])
]

{ #category : 'protocol' }
OPNodeCreationTool >> select [

	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal |
		oldVal ifNotNil: [ oldVal remove ] ].
	controller := factory value
]

{ #category : 'hooks' }
OPNodeCreationTool >> selectedControllers: aCollectionOfControllers [

	self selectedControllers: aCollectionOfControllers createdBy: [ :targetController | targetController addAsTargetFor: controller ]
]

{ #category : 'canvas events' }
OPNodeCreationTool >> selectedControllers: aCollectionOfControllers createdBy: aBlock [

	| targetController |
	aCollectionOfControllers size = 1 ifFalse: [ ^ self ].
	targetController := aCollectionOfControllers anyOne.
	(targetController canBeTargetFor: controller) ifFalse: [ ^ self ].
	aBlock value: targetController.
	self palette selectSelectionTool.
	controller roassalShape propertyAt: OPRSSelectable ifPresent: [ :selectable | selectable fakeClicked: controller roassalShape ].
	self doOnCompleteActions.
	controller := nil
]

{ #category : 'canvas events' }
OPNodeCreationTool >> selectedControllers: aCollectionOfControllers onPosition: aPoint [

	self
		selectedControllers: aCollectionOfControllers
		createdBy: [ :targetController | targetController addAsTargetFor: controller onPosition: aPoint ]
]
