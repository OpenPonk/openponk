"
Palette tool specifically designed for creating relationships (edges) between two existing diagram elements on the canvas. 
Manages the source selection, target selection, and hover feedback.
"
Class {
	#name : 'OPConnectionCreationTool',
	#superclass : 'OPPaletteTool',
	#instVars : [
		'connectionController',
		'factory',
		'feedback',
		'onComplete',
		'hoverAction',
		'selectionAction',
		'edgeCreationTargetController'
	],
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'protocol' }
OPConnectionCreationTool >> deselect [
	feedback value: nil.
	edgeCreationTargetController
		ifNotNil: [ 
			edgeCreationTargetController remove.
			edgeCreationTargetController := nil ]
]

{ #category : 'accessing' }
OPConnectionCreationTool >> factory: aBlock [
	factory := aBlock
]

{ #category : 'hooks' }
OPConnectionCreationTool >> hoveredController: aController [

	^ hoverAction value: aController
]

{ #category : 'callbacks' }
OPConnectionCreationTool >> hoveredSourceController: aController [

	feedback value: ((aController canBeSourceFor: connectionController)
			 ifTrue: [ aController showAcceptFeedbackFor: connectionController ]
			 ifFalse: [ aController showDenyFeedbackFor: connectionController ])
]

{ #category : 'callbacks' }
OPConnectionCreationTool >> hoveredTargetController: aController [

	feedback value: ((aController canBeTargetFor: connectionController)
			 ifTrue: [ aController showAcceptFeedbackFor: connectionController ]
			 ifFalse: [ aController showDenyFeedbackFor: connectionController ])
]

{ #category : 'initialization' }
OPConnectionCreationTool >> initialize [

	super initialize.
	self selectSource.
	onComplete := [ :ctrl |  ]
]

{ #category : 'protocol' }
OPConnectionCreationTool >> select [

	feedback := nil asValueHolder.
	feedback whenChangedDo: [ :newVal :oldVal |
			oldVal ifNotNil: [
					(newVal isNil or: [ oldVal feedback ~= newVal feedback ])
						ifTrue: [ oldVal remove ] ] ].
	connectionController := factory value.
	self selectSource
]

{ #category : 'protocol' }
OPConnectionCreationTool >> selectSource [

	hoverAction := [ :controller | self hoveredSourceController: controller ].
	selectionAction := [ :controllers | 
	                   self selectedSourceControllers: controllers ]
]

{ #category : 'protocol' }
OPConnectionCreationTool >> selectTarget [

	hoverAction := [ :controller | self hoveredTargetController: controller ].
	selectionAction := [ :controllers | 
	                   self selectedTargetControllers: controllers ]
]

{ #category : 'hooks' }
OPConnectionCreationTool >> selectedControllers: aCollectionOfControllers [

	^ selectionAction value: aCollectionOfControllers
]

{ #category : 'callbacks' }
OPConnectionCreationTool >> selectedSourceControllers: aCollectionOfControllers [

	| targetController |
	aCollectionOfControllers size = 1 ifFalse: [ ^ self ].
	targetController := aCollectionOfControllers anyOne.
	(targetController canBeSourceFor: connectionController) ifFalse: [ 
		^ self ].
	targetController addAsSourceFor: connectionController.
	edgeCreationTargetController := OPEdgeCreationTargetController 
		                                renderForEdgeController:
		                                connectionController.
	self selectTarget
]

{ #category : 'callbacks' }
OPConnectionCreationTool >> selectedTargetControllers: aCollectionOfControllers [

	| targetController |
	aCollectionOfControllers size = 1 ifFalse: [ ^ self ].
	targetController := aCollectionOfControllers anyOne.
	(targetController canBeTargetFor: connectionController) ifFalse: [
		^ self ].
	targetController addAsTargetFor: connectionController.
	self palette selectSelectionTool.
	connectionController roassalShape
		propertyAt: OPRSSelectable
		ifPresent: [ :selectable |
			selectable fakeClicked: connectionController roassalShape ].
	onComplete value: connectionController.
	connectionController := nil.
	self deselect
]

{ #category : 'tool api' }
OPConnectionCreationTool >> whenCreated: aOneArgBlock [
	onComplete := aOneArgBlock
]
