Class {
	#name : #OPDiagramFigureVeryVeryLightGrayColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'as yet unclassified' }
OPDiagramFigureVeryVeryLightGrayColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color veryVeryLightGray;
				asFormOfSize: 30@20
]

{ #category : #'as yet unclassified' }
OPDiagramFigureVeryVeryLightGrayColorCommand >> defaultMenuItemName [

	^ 'Very Very Light Gray'
]

{ #category : #'as yet unclassified' }
OPDiagramFigureVeryVeryLightGrayColorCommand >> execute [
	
	controllers do: [ :each | each diagramElement stylePropertyNamed: #fillColor
		put: Color veryVeryLightGray ]
]
