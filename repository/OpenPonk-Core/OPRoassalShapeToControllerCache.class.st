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
