Class {
	#name : #OPDiagramFigurePaleYellowColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleYellowColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color paleYellow;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleYellowColorCommand >> defaultMenuItemName [

	^ 'Pale Yellow'
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleYellowColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color paleYellow ]
]
