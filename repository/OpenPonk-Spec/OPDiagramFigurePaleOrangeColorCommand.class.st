Class {
	#name : #OPDiagramFigurePaleOrangeColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleOrangeColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color paleOrange;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleOrangeColorCommand >> defaultMenuItemName [

	^ 'Pale Orange'
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleOrangeColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color paleOrange ]
]
