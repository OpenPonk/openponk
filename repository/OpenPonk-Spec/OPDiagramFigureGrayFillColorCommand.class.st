Class {
	#name : 'OPDiagramFigureGrayFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'as yet unclassified' }
OPDiagramFigureGrayFillColorCommand >> color [

	^ Color veryVeryLightGray
]

{ #category : 'as yet unclassified' }
OPDiagramFigureGrayFillColorCommand >> defaultMenuItemName [

	^ 'Gray'
]
