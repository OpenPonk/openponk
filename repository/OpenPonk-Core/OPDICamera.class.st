Class {
	#name : #OPDICamera,
	#superclass : #OPDiagramCamera,
	#category : #'OpenPonk-Core-Shapes'
}

{ #category : #testing }
OPDICamera class >> isDeprecated [
	"replaced by superclass"

	^ true
]

{ #category : #'instance creation' }
OPDICamera class >> new [

	^ self superclass new
]
