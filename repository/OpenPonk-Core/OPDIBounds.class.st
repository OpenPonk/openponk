Class {
	#name : #OPDIBounds,
	#superclass : #OPNodeBounds,
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #testing }
OPDIBounds class >> isDeprecated [
	"replaced by superclass"

	^ true
]

{ #category : #'instance creation' }
OPDIBounds class >> new [

	^ self superclass new
]
