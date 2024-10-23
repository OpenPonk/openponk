Class {
	#name : 'OPDICamera',
	#superclass : 'OPDiagramCamera',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
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
