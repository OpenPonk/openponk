"
Context menu command that handles the deletion of the selected Roassal shape and its underlying domain model. 
Prompts for confirmation and coordinates the cascading removal of dependent elements via the controllers.
"
Class {
	#name : 'OPRemoveModelOfRoassalShapeCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'testing' }
OPRemoveModelOfRoassalShapeCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [ 
		  aToolContext roassalShapes anySatisfy: [ :any | any canvas ~= any ] ]
]

{ #category : 'activation' }
OPRemoveModelOfRoassalShapeCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: KeyboardKey delete asKeyCombination for: OPCanvasPresenter
]

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> basicExecute [
	roassalShapes do: [ :eachShape |
		(diagramController hasControllerForRoassalShape: eachShape) ifTrue: [
			diagramController removeModelOfRoassalShape: eachShape ] ]
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

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> execute [
	diagramController undoManager
		ifNotNil: [ :manager | manager inTransaction: [ self basicExecute ] ]
		ifNil: [ self basicExecute ].
	canvas signalUpdate
]

{ #category : 'execution' }
OPRemoveModelOfRoassalShapeCommand >> executeWithoutConfirmation [
	self execute
]
