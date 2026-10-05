"
A canvas command for applying white fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureWhiteFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureWhiteFillColorCommand class >> color [

	^ Color white
]
