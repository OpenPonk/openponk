Class {
	#name : #OPControllerFactoryRegistrationTest,
	#superclass : #TestCase,
	#instVars : [
		'factory',
		'registration'
	],
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #running }
OPControllerFactoryRegistrationTest >> testIsForModel [
	registration := OPControllerFactoryRegistration new modelClass: OPTestEntityModel.
	self assert: (registration isForModel: OPTestEntityModel new).
	self deny: (registration isForModel: OPTestRelationModel new)
]

{ #category : #running }
OPControllerFactoryRegistrationTest >> testIsForModelWithCondition [
	registration := OPControllerFactoryRegistration new
		modelClass: OPTestRelationModel;
		condition: [ :aModel | aModel source isNotNil ].
	self deny: (registration isForModel: OPTestRelationModel new).
	self assert: (registration isForModel: (OPTestRelationModel new source: 12))
]
