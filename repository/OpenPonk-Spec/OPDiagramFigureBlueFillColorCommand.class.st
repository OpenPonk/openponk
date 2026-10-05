"
A canvas command for applying blue fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureBlueFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureBlueFillColorCommand class >> color [

	^ Color paleBlue
]
