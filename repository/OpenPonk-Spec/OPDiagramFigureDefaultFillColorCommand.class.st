Class {
	#name : 'OPDiagramFigureDefaultFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#traits : 'OPTRoassalShapeDefaultColorCommand',
	#classTraits : 'OPTRoassalShapeDefaultColorCommand classTrait',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'accessing' }
OPDiagramFigureDefaultFillColorCommand >> defaultMenuItemName [

	^ self colorName
]
