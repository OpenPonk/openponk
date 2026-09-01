"
Context menu command that resets the fill color of the selected Roassal shape to its default value based on the element's style properties.
"
Class {
	#name : 'OPDiagramFigureDefaultFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#traits : 'OPTRoassalShapeDefaultColorCommand',
	#classTraits : 'OPTRoassalShapeDefaultColorCommand classTrait',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureDefaultFillColorCommand >> defaultMenuItemName [

	^ self colorName
]
