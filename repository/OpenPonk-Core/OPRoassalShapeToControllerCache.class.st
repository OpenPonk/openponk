"
Specialized cache that maps visual Roassal shapes to their governing element controllers within a diagram context.
"
Class {
	#name : 'OPRoassalShapeToControllerCache',
	#superclass : 'OPControllerCache',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'hooks' }
OPRoassalShapeToControllerCache >> keyOfController: aController [

	^ aController roassalShape
]
