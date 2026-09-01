"
Specialized cache that maps domain model instances to their corresponding element controllers within a diagram context.
"
Class {
	#name : 'OPModelToControllerCache',
	#superclass : 'OPControllerCache',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'hooks' }
OPModelToControllerCache >> keyOfController: aController [

	^ aController model
]
