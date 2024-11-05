Class {
	#name : 'OPControllerFactoryRegistrationTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'running' }
OPControllerFactoryRegistrationTest >> testIsForModelWithCondition [

	| registration |
	registration := OPModelHandlerFactoryRegistration new condition: [
		                :aModel | aModel source isNotNil ].
	self deny: (registration isForModel: OPTestRelationModel new).
	self assert:
		(registration isForModel: (OPTestRelationModel new source: 12))
]
