"
Deprecated legacy controller for relationships. 
Has been replaced by OPDirectionalRelationshipController and its subclasses.
"
Class {
	#name : 'OPRelationshipController',
	#superclass : 'OPDirectionalRelationshipController',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'testing' }
OPRelationshipController class >> isDeprecated [
	"Use my superclass instead"

	^ true
]
