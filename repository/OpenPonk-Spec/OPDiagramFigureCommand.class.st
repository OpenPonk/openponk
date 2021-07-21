"
I am command for figure context menu.
"
Class {
	#name : #OPDiagramFigureCommand,
	#superclass : #CmdCommand,
	#instVars : [
		'figure',
		'view',
		'diagramController',
		'figures',
		'models',
		'controllers'
	],
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #activation }
OPDiagramFigureCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byRootGroupItemFor: OPCanvasPresenter
]

{ #category : #example }
OPDiagramFigureCommand class >> example [
	| proj model |
	proj := OPProject new.
	model := OPTestContainerModel new.
	model entities add: OPTestEntityModel new.
	proj addModel: model.
	proj open
]

{ #category : #example }
OPDiagramFigureCommand class >> example2 [
	| c a |
	c := OPCanvasPresenter new.
	a := CmdContextMenuActivation
		buildContextMenuFor: c
		inContext: (OPDiagramFigureContext for: c).
	a openInWindow
]

{ #category : #testing }
OPDiagramFigureCommand class >> isAbstract [
	^ self = OPDiagramFigureCommand
]

{ #category : #execution }
OPDiagramFigureCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	diagramController := aToolContext diagramController.
	view := diagramController view.
	figures := aToolContext figures.
	figure := aToolContext figure.
	models := aToolContext models.
	controllers := aToolContext controllers
]
