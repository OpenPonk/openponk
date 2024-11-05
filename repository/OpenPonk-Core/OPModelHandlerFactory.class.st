"
I create new controllers for models.

Controllers are registered for models and optionally with a condition further clarifying the nature of the model required for the controller.
"
Class {
	#name : 'OPModelHandlerFactory',
	#superclass : 'Object',
	#instVars : [
		'registrations'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'accessing - defaults' }
OPModelHandlerFactory >> acceptAllCondition [
	^ [ :aModel | true ]
]

{ #category : 'hooks' }
OPModelHandlerFactory >> handlerKindName [

	^ self subclassResponsibility
]

{ #category : 'api - testing' }
OPModelHandlerFactory >> hasHandlerFor: aModel [

	^ (registrations at: aModel class ifAbsent: [ #(  ) ]) anySatisfy: [
		  :each | each isForModel: aModel ]
]

{ #category : 'initialization' }
OPModelHandlerFactory >> initialize [

	super initialize.
	registrations := Dictionary new
]

{ #category : 'api - accessing' }
OPModelHandlerFactory >> newHandlerFor: aModel [

	| handler errorBlock |
	errorBlock := [
	              self error:
		              'Unable to find ' , self handlerKindName
		              , ' class for model: ' , aModel asString ].
	handler := ((registrations at: aModel class ifAbsent: errorBlock)
		            detect: [ :any | any isForModel: aModel ]
		            ifNone: errorBlock) handlerClass new.
	handler model: aModel.
	^ handler
]

{ #category : 'api - registration' }
OPModelHandlerFactory >> register: aHandlerClass forModel: aModelClass [

	(registrations at: aModelClass ifAbsentPut: [ OrderedCollection new ])
		add: (self registrationClass forHandlerClass: aHandlerClass)
]

{ #category : 'api - registration' }
OPModelHandlerFactory >> register: aHandlerClass forModel: aModelClass condition: aConditionBlock [

	(registrations at: aModelClass ifAbsentPut: [ OrderedCollection new ])
		add: (self registrationClass
				 forHandlerClass: aHandlerClass
				 onCondition: aConditionBlock)
]

{ #category : 'accessing - defaults' }
OPModelHandlerFactory >> registrationClass [
	^ OPModelHandlerFactoryRegistration
]
