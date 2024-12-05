Class {
	#name : 'OPToggleRoassalShapeCommand',
	#superclass : 'OPRoassalShapeCommand',
	#instVars : [
		'executor'
	],
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'testing' }
OPToggleRoassalShapeCommand class >> canBeExecutedInContext: aToolContext [
	^ aToolContext plugin supportsHidingElements
		and: [ self canBeExecutedInModelContext: aToolContext ]
]

{ #category : 'testing' }
OPToggleRoassalShapeCommand class >> canBeExecutedInModelContext: aToolContext [

	^ aToolContext controllers anySatisfy: [ :any | any isHideable ]
]

{ #category : 'activation' }
OPToggleRoassalShapeCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: OPToggleRoassalShapeMenuGroup for: OPCanvasPresenter
]

{ #category : 'execution' }
OPToggleRoassalShapeCommand >> basicExecute [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPToggleRoassalShapeCommand >> defaultMenuItemName [

	^ ((((self class name withoutPrefix: 'OP') withoutSuffix:
		     'RoassalShapeCommand') splitCamelCase collect: #asLowercase)
		   joinUsing: ' ') capitalized
]

{ #category : 'execution' }
OPToggleRoassalShapeCommand >> execute [
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

{ #category : 'execution' }
OPToggleRoassalShapeCommand >> prepareFullExecutionInContext: aToolContext [

	super prepareFullExecutionInContext: aToolContext.
	executor := OPDiagramExplorer on: diagramController
]
