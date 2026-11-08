"
Palette tool specifically designed for creating relationships (edges) between two existing diagram elements on the canvas. 
Manages the source selection, target selection, and hover feedback.
"
Class {
	#name : 'OPConnectionCreationTool',
	#superclass : 'OPCreationTool',
	#instVars : [
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
OPConnectionCreationTool >> hoveredController: aSourceOrTargetController [

	^ hoverAction value: aSourceOrTargetController
]

{ #category : 'callbacks' }
OPConnectionCreationTool >> hoveredSourceController: aSourceController [

	feedback value: ((aSourceController canBeSourceFor: controller)
			 ifTrue: [ aSourceController showAcceptFeedbackFor: controller ]
			 ifFalse: [ aSourceController showDenyFeedbackFor: controller ])
]

{ #category : 'callbacks' }
OPConnectionCreationTool >> hoveredTargetController: aTargetController [

	feedback value: ((aTargetController canBeTargetFor: controller)
			 ifTrue: [ aTargetController showAcceptFeedbackFor: controller ]
			 ifFalse: [ aTargetController showDenyFeedbackFor: controller ])
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
	controller := factory value.
	self selectSource
]

{ #category : 'protocol' }
OPConnectionCreationTool >> selectSource [

	hoverAction := [ :sourceController | self hoveredSourceController: sourceController ].
	selectionAction := [ :sourceControllers | self selectedSourceControllers: sourceControllers ]
]

{ #category : 'protocol' }
OPConnectionCreationTool >> selectTarget [

	hoverAction := [ :targetController | self hoveredTargetController: targetController ].
	selectionAction := [ :targetControllers | self selectedTargetControllers: targetControllers ]
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
	(targetController canBeSourceFor: controller) ifFalse: [ ^ self ].
	targetController addAsSourceFor: controller.
	edgeCreationTargetController := OPEdgeCreationTargetController renderForEdgeController: controller.
	self selectTarget
]

{ #category : 'callbacks' }
OPConnectionCreationTool >> selectedTargetControllers: aCollectionOfControllers [

	| targetController |
	aCollectionOfControllers size = 1 ifFalse: [ ^ self ].
	targetController := aCollectionOfControllers anyOne.
	(targetController canBeTargetFor: controller) ifFalse: [ ^ self ].
	targetController addAsTargetFor: controller.
	self palette selectSelectionTool.
	controller roassalShape propertyAt: OPRSSelectable ifPresent: [ :selectable | selectable fakeClicked: controller roassalShape ].
	self doOnCompleteActions.
	self deselect
]

{ #category : 'tool api' }
OPConnectionCreationTool >> whenCreated: aOneArgBlock [
	onComplete := aOneArgBlock
]
