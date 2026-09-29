"
Context menu command that sets the fill color of the selected Roassal shape to orange.
"
Class {
	#name : 'OPDiagramFigureOrangeFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureOrangeFillColorCommand class >> color [

	^ Color paleOrange
]
