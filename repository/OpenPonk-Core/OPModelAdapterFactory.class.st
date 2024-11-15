Class {
	#name : 'OPModelAdapterFactory',
	#superclass : 'OPModelHandlerFactory',
	#category : 'OpenPonk-Core-Adapters',
	#package : 'OpenPonk-Core',
	#tag : 'Adapters'
}

{ #category : 'hooks' }
OPModelAdapterFactory >> handlerKindName [

	^ 'adapter'
]

{ #category : 'testing' }
OPModelAdapterFactory >> hasAdapterFor: aModel [

	^ self hasHandlerFor: aModel
]

{ #category : 'instance creation' }
OPModelAdapterFactory >> newAdapterFor: aModel [

	^ self newHandlerFor: aModel
]
