Class {
	#name : 'OPDIBounds',
	#superclass : 'OPNodeBounds',
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'testing' }
OPDIBounds class >> isDeprecated [
	"replaced by superclass"

	^ true
]

{ #category : 'instance creation' }
OPDIBounds class >> new [

	^ self superclass new
]
