Class {
	#name : 'OPDiagramFigureGrayFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'as yet unclassified' }
OPDiagramFigureGrayFontColorCommand >> color [

	^ Color lightGray
]

{ #category : 'as yet unclassified' }
OPDiagramFigureGrayFontColorCommand >> defaultMenuItemName [

	^ 'Gray'
]
