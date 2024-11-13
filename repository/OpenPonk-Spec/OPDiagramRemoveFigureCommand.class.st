Class {
	#name : 'OPDiagramRemoveFigureCommand',
	#superclass : 'OPDiagramFigureCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'testing' }
OPDiagramRemoveFigureCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [ 
		  aToolContext figures anySatisfy: [ :any | any canvas ~= any ] ]
]

{ #category : 'testing' }
OPDiagramRemoveFigureCommand class >> canvasShortcutActivation [

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
OPDiagramRemoveFigureCommand class >> lastEvent [

	self flag:
		'Part of ugly hack to find out if the modifier key was pressed'.
		
	^ lastEvent
]

{ #category : 'accessing' }
OPDiagramRemoveFigureCommand class >> lastEvent: anEvent [

	self flag:
		'Part of ugly hack to find out if the modifier key was pressed'.

	lastEvent := anEvent
]

{ #category : 'constants' }
OPDiagramRemoveFigureCommand class >> skipConfirmationModifier [

	^ KMModifier shift
]

{ #category : 'accessing' }
OPDiagramRemoveFigureCommand >> defaultMenuIconName [

	^ #glamorousTrash
]

{ #category : 'accessing' }
OPDiagramRemoveFigureCommand >> defaultMenuItemName [

	^ (models isNil or: [ models size = 1 ])
		  ifTrue: [ 'Remove from model' ]
		  ifFalse: [ 'Remove all ' , models size asString , ' from model' ]
]

{ #category : 'utilities' }
OPDiagramRemoveFigureCommand >> doAndReturnFocus: aBlock [

	| result window wasActive |
	window := diagramController canvasPresenter window window.
	wasActive := window isActive.
	result := aBlock value.
	window activate.
	^ result
]

{ #category : 'execution' }
OPDiagramRemoveFigureCommand >> execute [

	self class lastEvent ifNotNil: [ :lastEvent |
		(self class skipConfirmationModifier matchesEvent: lastEvent)
			ifTrue: [ ^ self executeWithoutConfirmation ] ].
	self executeWithConfirmation
]

{ #category : 'execution' }
OPDiagramRemoveFigureCommand >> executeWithConfirmation [

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
OPDiagramRemoveFigureCommand >> executeWithoutConfirmation [

	| allShown |
	diagramController deselectAll.

	allShown := self showDependentAndReturnOriginallyShown.

	figures do: [ :each |
		(diagramController hasControllerForFigure: each) ifTrue: [
			diagramController removeModelOfRoassalShape: each ] ].

	self removeAllNotOriginallyShown: allShown.

	canvas signalUpdate
]

{ #category : 'execution' }
OPDiagramRemoveFigureCommand >> removeAllNotOriginallyShown: allShown [

	diagramController allVisibleShowableElements
		reject: [ :any | allShown includes: any ]
		thenDo: [ :each |
			diagramController
				controllerForModel: each
				ifFound: [ :controller |
				controller removeControllerAndDiagramElement ] ]
]

{ #category : 'execution' }
OPDiagramRemoveFigureCommand >> showDependentAndReturnOriginallyShown [

	| executor allShown dependent |
	executor := OPDiagramExplorer on: diagramController.
	allShown := diagramController allVisibleShowableElements asSet.
	dependent := models flatCollect: [ :each |
		             executor dependentFor: each ].
	executor showElements: dependent.
	^ allShown
]
