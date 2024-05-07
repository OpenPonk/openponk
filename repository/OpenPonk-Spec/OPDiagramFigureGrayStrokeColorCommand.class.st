Class {
	#name : 'OPDiagramFigureGrayStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'as yet unclassified' }
OPDiagramFigureGrayStrokeColorCommand >> color [

	^ Color lightGray
]

{ #category : 'as yet unclassified' }
OPDiagramFigureGrayStrokeColorCommand >> defaultMenuItemName [

	^ 'Gray'
]
