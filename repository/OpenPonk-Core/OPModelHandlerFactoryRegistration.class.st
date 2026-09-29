"
Represents a single registration entry within OPModelHandlerFactory, mapping a model class and an optional condition to a specific handler class.
"
Class {
	#name : 'OPModelHandlerFactoryRegistration',
	#superclass : 'Object',
	#instVars : [
		'modelClass',
		'condition',
		'handlerClass'
	],
	#category : 'OpenPonk-Core-ViewModels',
	#package : 'OpenPonk-Core',
	#tag : 'ViewModels'
}

{ #category : 'instance creation' }
OPModelHandlerFactoryRegistration class >> forHandlerClass: aClass [

	^ self new
		  handlerClass: aClass;
		  yourself
]

{ #category : 'instance creation' }
OPModelHandlerFactoryRegistration class >> forHandlerClass: aClass onCondition: aConditionBlock [

	^ (self forHandlerClass: aClass)
		  condition: aConditionBlock;
		  yourself
]

{ #category : 'accessing' }
OPModelHandlerFactoryRegistration >> condition [

	^ condition
]

{ #category : 'accessing' }
OPModelHandlerFactoryRegistration >> condition: aBlock [
	condition := aBlock
]

{ #category : 'accessing' }
OPModelHandlerFactoryRegistration >> handlerClass [
	^ handlerClass
]

{ #category : 'accessing' }
OPModelHandlerFactoryRegistration >> handlerClass: anObject [
	handlerClass := anObject
]

{ #category : 'initialization' }
OPModelHandlerFactoryRegistration >> initialize [

	super initialize.
	condition := [ :aModel | true ]
]

{ #category : 'testing' }
OPModelHandlerFactoryRegistration >> isForModel: aModel [

	^ self condition value: aModel
]

{ #category : 'accessing' }
OPModelHandlerFactoryRegistration >> modelClass [
	^ modelClass
]

{ #category : 'accessing' }
OPModelHandlerFactoryRegistration >> modelClass: anObject [
	modelClass := anObject
]

{ #category : 'printing' }
OPModelHandlerFactoryRegistration >> printOn: stream [

	super printOn: stream.
	stream << ' (' << self handlerClass asString << ')'
]
