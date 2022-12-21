Class {
	#name : #OPDiagramFigurePaleGreenColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleGreenColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color paleGreen;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleGreenColorCommand >> defaultMenuItemName [

	^ 'Pale Green'
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleGreenColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color paleGreen ]
]
