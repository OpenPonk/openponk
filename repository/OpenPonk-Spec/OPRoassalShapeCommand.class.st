"
I am command for figure context menu.
"
Class {
	#name : 'OPRoassalShapeCommand',
	#superclass : 'CmdCommand',
	#instVars : [
		'canvas',
		'diagramController',
		'models',
		'controllers',
		'diagramElements',
		'roassalShapes'
	],
	#classInstVars : [
		'lastEvent'
	],
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'activation' }
OPRoassalShapeCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor: OPCanvasPresenter
]

{ #category : 'example' }
OPRoassalShapeCommand class >> example [
	| proj model |
	proj := OPProject new.
	model := OPTestContainerModel new.
	model entities add: OPTestEntityModel new.
	proj addModel: model.
	proj open
]

{ #category : 'example' }
OPRoassalShapeCommand class >> example2 [
	| c a |
	c := OPCanvasPresenter new.
	a := CmdContextMenuActivation
		buildContextMenuFor: c
		inContext: (OPRoassalShapeContext for: c).
	a openInWindow
]

{ #category : 'testing' }
OPRoassalShapeCommand class >> isAbstract [
	^ self = OPRoassalShapeCommand
]

{ #category : 'execution' }
OPRoassalShapeCommand >> readParametersFromContext: aToolContext [

	super readParametersFromContext: aToolContext.

	diagramController := aToolContext diagramController.
	canvas := diagramController canvas.
	roassalShapes := aToolContext roassalShapes.
	models := aToolContext models.
	controllers := aToolContext controllers.
	diagramElements := aToolContext diagramElements
]
