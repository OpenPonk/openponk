Class {
	#name : #OPDiagramFigureTransparentColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigureTransparentColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color white;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigureTransparentColorCommand >> defaultMenuItemName [

	^ 'Transparent'
]

{ #category : #'as yet unclassified' }
OPDiagramFigureTransparentColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color transparent ]
]
