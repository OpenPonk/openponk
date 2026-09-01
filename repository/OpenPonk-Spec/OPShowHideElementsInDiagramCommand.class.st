"
Diagram toolbar command that opens a specialized dialog (explorer) allowing the user to selectively show or hide specific model elements within the current diagram.
"
Class {
	#name : 'OPShowHideElementsInDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'testing' }
OPShowHideElementsInDiagramCommand class >> canBeExecutedInContext: aToolContext [
	^ aToolContext editor plugin supportsHidingElements
]

{ #category : 'accessing' }
OPShowHideElementsInDiagramCommand >> defaultMenuIconFormSet [

	^ FormSet form: OPIdeaActionsIcons propertiesIcon
]

{ #category : 'accessing' }
OPShowHideElementsInDiagramCommand >> defaultMenuItemName [
	^ 'Show/Hide Elements'
]

{ #category : 'execution' }
OPShowHideElementsInDiagramCommand >> execute [

	(OPShowHidePresenter
		 newApplication: diagramPresenter application
		 model: diagramPresenter diagramController) open
]
