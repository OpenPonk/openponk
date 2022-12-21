Class {
	#name : #OPDiagramFigurePaleRedColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleRedColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color paleRed;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleRedColorCommand >> defaultMenuItemName [

	^ 'Pale Red'
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleRedColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color paleRed ]
]
