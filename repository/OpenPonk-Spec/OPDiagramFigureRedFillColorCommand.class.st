"
A canvas command for applying red fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureRedFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureRedFillColorCommand class >> color [

	^ Color paleRed
]
