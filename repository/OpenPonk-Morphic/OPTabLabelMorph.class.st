"
I am a customized Morphic tab label. I extend TabLabelMorph to override the default selection fill styles and border rendering, ensuring tab headers within OpenPonk's notebook interfaces align with the application's specific visual theme.
"
Class {
	#name : 'OPTabLabelMorph',
	#superclass : 'TabLabelMorph',
	#category : 'OpenPonk-Morphic-Morphic',
	#package : 'OpenPonk-Morphic',
	#tag : 'Morphic'
}

{ #category : 'accessing' }
OPTabLabelMorph >> borderStyleToUse [

	"Answer the borderStyle that should be used for the receiver."

	^ self borderStyle
]

{ #category : 'style' }
OPTabLabelMorph >> selectedFillStyle [

	^ super selectedFillStyle
		  color: super normalFillStyle asColor darker;
		  yourself
]
