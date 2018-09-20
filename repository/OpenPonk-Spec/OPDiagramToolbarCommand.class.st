"
I am command for diagram toolbar.
"
Class {
	#name : #OPDiagramToolbarCommand,
	#superclass : #CmdCommand,
	#instVars : [
		'diagramPresenter'
	],
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPDiagramToolbarCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation byRootGroupItemOrder: 100 for: OPCanvasModel
]

{ #category : #accessing }
OPDiagramToolbarCommand >> defaultMenuItemName [
	^ nil
]

{ #category : #execution }
OPDiagramToolbarCommand >> prepareFullExecutionInContext: aToolContext [
	super prepareFullExecutionInContext: aToolContext.
	diagramPresenter := aToolContext
]
