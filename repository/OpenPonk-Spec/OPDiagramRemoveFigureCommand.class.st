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
						    modifiedBy: KMModifier meta) })
		  for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPDiagramRemoveFigureCommand class >> lastEvent [

	self flag:
		'Part of ugly hack to find out if ctrl is currently pressed'.
		
	^ lastEvent
]

{ #category : 'accessing' }
OPDiagramRemoveFigureCommand class >> lastEvent: anEvent [

	self flag:
		'Part of ugly hack to find out if ctrl is currently pressed'.

	lastEvent := anEvent
]

{ #category : 'accessing' }
OPDiagramRemoveFigureCommand >> defaultMenuIcon [
	^ self iconNamed: #glamorousTrash
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

	| lastEvent |
	lastEvent := self class lastEvent.
	(lastEvent isNotNil and: [
		 lastEvent controlKeyPressed or: [ lastEvent commandKeyPressed ] ])
		ifTrue: [ self unsafeExecute ]
		ifFalse: [ self safeExecute ]
]

{ #category : 'execution' }
OPDiagramRemoveFigureCommand >> safeExecute [

	| result |
	result := self doAndReturnFocus: [
		          UIManager default
			          proceed:
				          'Permanently remove from model? (to skip this confirmation, hold '
				          , OSPlatform current defaultModifier name
				          , ' next time)'
			          title: 'Remove?' ].
	result ifNil: [ ^ self ].
	result ifFalse: [ ^ self ].
	self unsafeExecute
]

{ #category : 'execution' }
OPDiagramRemoveFigureCommand >> unsafeExecute [

	diagramController deselectAll.
	figures do: [ :each |
		(diagramController hasControllerForFigure: each) ifTrue: [
			diagramController removeModelOfRoassalShape: each ] ].
	canvas signalUpdate
]
