"
A canvas command for applying yellow fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureYellowFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureYellowFillColorCommand class >> color [

	^ Color paleYellow
]
