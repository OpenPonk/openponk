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
