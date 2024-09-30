Class {
	#name : 'OPDIOpenPonkStyle',
	#superclass : 'OPOpenPonkShapeStyle',
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'testing' }
OPDIOpenPonkStyle class >> isDeprecated [
	"replaced by superclass"

	^ true
]

{ #category : 'instance creation' }
OPDIOpenPonkStyle class >> new [

	^ self superclass new
]
