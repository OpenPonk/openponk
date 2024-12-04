Class {
	#name : 'OPRemoveModelOfRoassalShapeCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'testing' }
OPRemoveModelOfRoassalShapeCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [ 
		  aToolContext roassalShapes anySatisfy: [ :any | any canvas ~= any ] ]
]

{ #category : 'testing' }
OPRemoveModelOfRoassalShapeCommand class >> canvasShortcutActivation [

	<classAnnotation>
	^ CmdShortcutActivation
		  by: (KMKeyCombinationChoice withShortcuts: {
					   (KMSingleKeyCombination new key:
						    (KeyboardKey new withValue: 16rffff andName: #delete)).
					   ((KMSingleKeyCombination new key:
						     (KeyboardKey new withValue: 16rffff andName: #delete))
						    modifiedBy: self skipConfirmationModifier) })
		  for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPRemoveModelOfRoassalShapeCommand class >> lastEvent [

	self flag:
		'Part of ugly hack to find out if the modifier key was pressed'.
		
	^ lastEvent
]

{ #category : 'accessing' }
OPRemoveModelOfRoassalShapeCommand class >> lastEvent: anEvent [

	self flag:
		'Part of ugly hack to find out if the modifier key was pressed'.

	lastEvent := anEvent
]

{ #category : 'constants' }
OPRemoveModelOfRoassalShapeCommand class >> skipConfirmationModifier [

	^ KMModifier shift
]

{ #category : 'accessing' }
OPRemoveModelOfRoassalShapeCommand >> defaultMenuIconName [

	^ #glamorousTrash
]

{ #category : 'accessing' }
OPRemoveModelOfRoassalShapeCommand >> defaultMenuItemName [

	^ (models isNil or: [ models size = 1 ])
		  ifTrue: [ 'Remove from model' ]
		  ifFalse: [ 'Remove all ' , models size asString , ' from model' ]
]

{ #category : 'utilities' }
OPRemoveModelOfRoassalShapeCommand >> doAndReturnFocus: aBlock [

	| result window wasActive |
	window := diagramController canvasPresenter window window.
	wasActive := window isActive.
	result := aBlock value.
	window activate.
	^ result
]

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> execute [

	self class lastEvent ifNotNil: [ :lastEvent |
		(self class skipConfirmationModifier matchesEvent: lastEvent)
			ifTrue: [ ^ self executeWithoutConfirmation ] ].
	self executeWithConfirmation
]

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> executeWithConfirmation [

	| result |
	result := self doAndReturnFocus: [
		          UIManager default
			          proceed:
				          'Permanently remove from model? (to skip this confirmation, hold '
				          , self class skipConfirmationModifier name
				          , ' next time)'
			          title: 'Remove?' ].
	result ifNil: [ ^ self ].
	result ifFalse: [ ^ self ].
	self executeWithoutConfirmation
]

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> executeWithoutConfirmation [

	| allShown |
	allShown := self showDependentAndReturnOriginallyShown.

	roassalShapes do: [ :each |
		(diagramController hasControllerForRoassalShape: each) ifTrue: [
			diagramController removeModelOfRoassalShape: each ] ].

	self removeAllNotOriginallyShown: allShown.

	canvas signalUpdate
]

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> removeAllNotOriginallyShown: allShown [

	diagramController allModelElementsWithController
		reject: [ :any | allShown includes: any ]
		thenDo: [ :each |
			diagramController
				controllerForModel: each
				ifFound: [ :controller |
				controller removeControllerAndDiagramElement ] ]
]

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> showDependentAndReturnOriginallyShown [

	| executor allShown dependent |
	executor := OPDiagramExplorer on: diagramController.
	allShown := diagramController allModelElementsWithController asSet.
	dependent := models flatCollect: [ :each |
		             executor dependentFor: each ].
	executor showElements: dependent.
	^ allShown
]
