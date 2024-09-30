Class {
	#name : 'OPDiagramFigureTransparentFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'as yet unclassified' }
OPDiagramFigureTransparentFillColorCommand >> color [

	^ Color transparent
]

{ #category : 'as yet unclassified' }
OPDiagramFigureTransparentFillColorCommand >> defaultMenuIcon [

	^ Morph new 
				color: Color white;
				asFormOfSize: 30@20
]

{ #category : 'as yet unclassified' }
OPDiagramFigureTransparentFillColorCommand >> defaultMenuItemName [

	^ 'Transparent'
]
