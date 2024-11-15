Class {
	#name : 'OPShowHideElementsInDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Toolbar-Commands'
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
