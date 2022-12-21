Class {
	#name : #OPDiagramFigurePaleMagentaColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleMagentaColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color paleMagenta;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleMagentaColorCommand >> defaultMenuItemName [

	^ 'Pale Magenta'
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleMagentaColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color paleMagenta ]
]
