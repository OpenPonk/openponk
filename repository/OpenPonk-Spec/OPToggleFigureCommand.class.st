Class {
	#name : #OPToggleFigureCommand,
	#superclass : #OPDiagramFigureCommand,
	#instVars : [
		'controller',
		'model',
		'executor'
	],
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPToggleFigureCommand class >> canBeExecutedInContext: aToolContext [
	^ aToolContext plugin supportsHidingElements
		and: [ self canBeExecutedInModelContext: aToolContext ]
]

{ #category : #testing }
OPToggleFigureCommand class >> canBeExecutedInModelContext: aToolContext [
	^ false
]

{ #category : #activation }
OPToggleFigureCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: OPToggleFigureMenuGroup for: OPCanvasPresenter
]

{ #category : #execution }
OPToggleFigureCommand >> basicExecute [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPToggleFigureCommand >> defaultMenuItemName [
	^ ((((self class name withoutPrefix: 'OP')
		withoutSuffix: 'FigureCommand') splitOnCapitals
		collect: #asLowercase) joinUsing: ' ') capitalized
]

{ #category : #execution }
OPToggleFigureCommand >> execute [
	| oldView newView |
	oldView := diagramController viewState.
	self basicExecute.
	newView := diagramController viewState.
	diagramController undoManager
		redoArray:
			{diagramController.
			#viewState:.
			{newView}}
		undoArray:
			{diagramController.
			#viewState:.
			{oldView}}
]

{ #category : #accessing }
OPToggleFigureCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	controller := diagramController controllerForFigure: figure.
	model := controller model.
	executor := OPDiagramExplorer on: diagramController
]
