"
Context menu command that sets the fill color of the selected Roassal shape to magenta.
"
Class {
	#name : 'OPDiagramFigureMagentaFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureMagentaFillColorCommand class >> color [

	^ Color paleMagenta
]
