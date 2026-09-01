"
Context menu command that sets the fill color of the selected Roassal shape to be fully transparent.
"
Class {
	#name : 'OPDiagramFigureTransparentFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureTransparentFillColorCommand class >> color [

	^ Color transparent
]

{ #category : 'accessing' }
OPDiagramFigureTransparentFillColorCommand >> defaultMenuIconFormSet [

	^ nil
]
