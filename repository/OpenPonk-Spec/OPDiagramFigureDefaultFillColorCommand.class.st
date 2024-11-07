Class {
	#name : 'OPDiagramFigureDefaultFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#traits : 'OPTDiagramFigureDefaultColorCommand',
	#classTraits : 'OPTDiagramFigureDefaultColorCommand classTrait',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'accessing' }
OPDiagramFigureDefaultFillColorCommand >> defaultMenuItemName [

	^ self colorName
]
