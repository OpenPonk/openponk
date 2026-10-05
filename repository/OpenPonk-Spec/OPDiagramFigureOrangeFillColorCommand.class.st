"
A canvas command for applying orange fillColor to selected diagram elements.
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
