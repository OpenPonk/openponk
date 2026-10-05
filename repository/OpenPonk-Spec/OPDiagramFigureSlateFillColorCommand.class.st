"
A canvas command for applying slate fillColor to selected diagram elements.
"
Class {
	#name : 'OPDiagramFigureSlateFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureSlateFillColorCommand class >> color [

	^ (Color fromHexString: 'DCE5EC')
]

{ #category : 'accessing' }
OPDiagramFigureSlateFillColorCommand >> colorName [

	^ 'Slate'
]
