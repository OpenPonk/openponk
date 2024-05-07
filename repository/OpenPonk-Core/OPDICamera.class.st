Class {
	#name : 'OPDICamera',
	#superclass : 'OPDiagramCamera',
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'testing' }
OPDICamera class >> isDeprecated [
	"replaced by superclass"

	^ true
]

{ #category : 'instance creation' }
OPDICamera class >> new [

	^ self superclass new
]
