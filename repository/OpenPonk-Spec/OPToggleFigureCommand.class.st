Class {
	#name : #OPToggleFigureCommand,
	#superclass : #OPDiagramFigureCommand,
	#instVars : [
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

	^ aToolContext controllers anySatisfy: [ :any | any isHideable ]
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

	| basicName |
	basicName := ((((self class name withoutPrefix: 'OP') withoutSuffix:
		                'FigureCommand') splitOnCapitals collect:
		               #asLowercase) joinUsing: ' ') capitalized.
	models ifNil: [ ^ basicName ].
	^ models size pluralize: basicName
]

{ #category : #execution }
OPToggleFigureCommand >> execute [
	"| oldView newView |
	oldView := diagramController viewState."
	self basicExecute.
	"newView := diagramController viewState.
	diagramController undoManager
		redoArray:
			{diagramController.
			#viewState:.
			{newView}}
		undoArray:
			{diagramController.
			#viewState:.
			{oldView}}"
]

{ #category : #accessing }
OPToggleFigureCommand >> prepareFullExecutionInContext: aToolContext [

	super prepareFullExecutionInContext: aToolContext.
	executor := OPDiagramExplorer on: diagramController
]
