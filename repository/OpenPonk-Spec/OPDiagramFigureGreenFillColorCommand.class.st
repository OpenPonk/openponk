"
A canvas command for applying green fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureGreenFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGreenFillColorCommand class >> color [

	^ Color paleGreen
]
