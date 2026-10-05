"
A canvas command for applying gray fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureGrayFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGrayFillColorCommand class >> color [

	^ Color veryVeryLightGray
]
