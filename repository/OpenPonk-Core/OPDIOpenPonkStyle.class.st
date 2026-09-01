"
Deprecated legacy class representing a shape style. Use OPOpenPonkShapeStyle instead.
"
Class {
	#name : 'OPDIOpenPonkStyle',
	#superclass : 'OPOpenPonkShapeStyle',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
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
