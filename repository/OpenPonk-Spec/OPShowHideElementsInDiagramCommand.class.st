Class {
	#name : #OPShowHideElementsInDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #testing }
OPShowHideElementsInDiagramCommand class >> canBeExecutedInContext: aToolContext [
	^ aToolContext editor plugin supportsHidingElements
]

{ #category : #execution }
OPShowHideElementsInDiagramCommand >> defaultMenuIcon [
	^ OPIdeaActionsIcons propertiesIcon
]

{ #category : #execution }
OPShowHideElementsInDiagramCommand >> defaultMenuItemName [
	^ 'Show/Hide Elements'
]

{ #category : #execution }
OPShowHideElementsInDiagramCommand >> execute [
	OPShowHideElementsBrowser new openOn: diagramPresenter diagramController
]
