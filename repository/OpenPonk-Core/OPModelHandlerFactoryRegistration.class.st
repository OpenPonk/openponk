"
Represents a single registration entry within a model handler factory, pairing an optional condition block with a handler class.
"
Class {
	#name : 'OPModelHandlerFactoryRegistration',
	#superclass : 'Object',
	#instVars : [
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

{ #category : 'printing' }
OPModelHandlerFactoryRegistration >> printOn: stream [

	super printOn: stream.
	stream << ' (' << self handlerClass asString << ')'
]
