"
A canvas command for applying magenta fillColor to selected diagram elements.
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
