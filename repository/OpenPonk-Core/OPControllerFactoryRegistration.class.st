Class {
	#name : #OPControllerFactoryRegistration,
	#superclass : #Object,
	#instVars : [
		'controllerClass',
		'modelClass',
		'condition'
	],
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #accessing }
OPControllerFactoryRegistration >> condition [
	^ condition ifNil: [ [ :aModel | true ] ]
]

{ #category : #accessing }
OPControllerFactoryRegistration >> condition: aBlock [
	condition := aBlock
]

{ #category : #accessing }
OPControllerFactoryRegistration >> controllerClass [
	^ controllerClass
]

{ #category : #accessing }
OPControllerFactoryRegistration >> controllerClass: anObject [
	controllerClass := anObject
]

{ #category : #accessing }
OPControllerFactoryRegistration >> isForModel: aModel [
	^ aModel class = self modelClass and: [ self condition value: aModel ]
]

{ #category : #accessing }
OPControllerFactoryRegistration >> modelClass [
	^ modelClass
]

{ #category : #accessing }
OPControllerFactoryRegistration >> modelClass: anObject [
	modelClass := anObject
]

{ #category : #printing }
OPControllerFactoryRegistration >> printOn: stream [
	super printOn: stream.
	stream << ' (' << self modelClass asString << ' -> '
		<< self controllerClass asString << ')'
]
