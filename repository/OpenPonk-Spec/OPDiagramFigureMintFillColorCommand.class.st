"
A canvas command for applying mint fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureMintFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureMintFillColorCommand class >> color [

	^ (Color fromHexString: 'D6FCEB')
]

{ #category : 'accessing' }
OPDiagramFigureMintFillColorCommand >> colorName [

	^ 'Mint'
]
