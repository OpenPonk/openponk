Class {
	#name : #OPDiagramFigurePaleBlueColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleBlueColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color paleBlue;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleBlueColorCommand >> defaultMenuItemName [

	^ 'Pale Blue'
]

{ #category : #'as yet unclassified' }
OPDiagramFigurePaleBlueColorCommand >> execute [

	controllers do: [ :each | 
		each diagramElement
			stylePropertyNamed: #fillColor
			put: Color paleBlue ]
]
