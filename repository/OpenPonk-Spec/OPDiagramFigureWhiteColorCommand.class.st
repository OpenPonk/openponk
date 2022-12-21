Class {
	#name : #OPDiagramFigureWhiteColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigureWhiteColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color white;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigureWhiteColorCommand >> defaultMenuItemName [

	^ 'White'
]

{ #category : #'as yet unclassified' }
OPDiagramFigureWhiteColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color white ]
]
