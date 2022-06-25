Class {
	#name : #OPTabLabelMorph,
	#superclass : #TabLabelMorph,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #accessing }
OPTabLabelMorph >> borderStyleToUse [

	"Answer the borderStyle that should be used for the receiver."

	^ self borderStyle
]

{ #category : #style }
OPTabLabelMorph >> selectedFillStyle [

	^ super selectedFillStyle
		  color: super normalFillStyle asColor darker;
		  yourself
]
