"
A canvas command for applying transparent fillColor to selected diagram elements.
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
OPDiagramFigureTransparentFillColorCommand >> defaultMenuIcon [
	^ Morph new
		color: Color white;
		asFormOfSize: 30@20
]

{ #category : 'accessing' }
OPDiagramFigureTransparentFillColorCommand >> defaultMenuIconFormSet [

	^ nil
]
