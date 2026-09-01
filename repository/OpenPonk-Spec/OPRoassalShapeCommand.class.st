"
Abstract base class for Commander framework commands that operate on visual Roassal shapes via context menus or shortcuts. 
Resolves the context to map selected shapes to their corresponding diagram elements, ViewModels, and controllers.
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
		'roassalShapes',
		'viewModels'
	],
	#classInstVars : [
		'lastEvent'
	],
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
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

{ #category : 'accessing' }
OPRoassalShapeCommand >> diagramController [

	^ diagramController
]

{ #category : 'execution' }
OPRoassalShapeCommand >> readParametersFromContext: aToolContext [

	super readParametersFromContext: aToolContext.

	diagramController := aToolContext diagramController.
	canvas := diagramController canvas.
	roassalShapes := aToolContext roassalShapes.
	controllers := aToolContext controllers.
	diagramElements := aToolContext diagramElements.
	viewModels := aToolContext viewModels.
	models := aToolContext models
]
