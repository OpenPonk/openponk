Class {
	#name : #OPDIOpenPonkStyle,
	#superclass : #OPOpenPonkShapeStyle,
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #testing }
OPDIOpenPonkStyle class >> isDeprecated [
	"replaced by superclass"

	^ true
]

{ #category : #'instance creation' }
OPDIOpenPonkStyle class >> new [

	^ self superclass new
]
