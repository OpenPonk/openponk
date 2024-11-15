Class {
	#name : 'OPControllerFactory',
	#superclass : 'OPModelHandlerFactory',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'instance creation' }
OPControllerFactory class >> withCommonElements [
	^ self new registerCommonElements
]

{ #category : 'hooks' }
OPControllerFactory >> handlerKindName [

	^ 'controller'
]

{ #category : 'api - testing' }
OPControllerFactory >> hasControllerFor: aModel [

	^ self hasHandlerFor: aModel
]

{ #category : 'api - accessing' }
OPControllerFactory >> newControllerFor: aModel [

	^ self newHandlerFor: aModel
]

{ #category : 'hooks' }
OPControllerFactory >> registerCommonElements [
	OPCommonElementController
		allSubclassesDo: [ :each | self register: each forModel: each modelClass ]
]
