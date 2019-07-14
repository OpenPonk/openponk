"
I create new controllers for models.

Controllers are registered for models and optionally with a condition further clarifying the nature of the model required for the controller.
"
Class {
	#name : #OPControllerFactory,
	#superclass : #Object,
	#instVars : [
		'registrations'
	],
	#category : 'OpenPonk-Core-Controllers'
}

{ #category : #'accessing - defaults' }
OPControllerFactory >> acceptAllCondition [
	^ [ :aModel | true ]
]

{ #category : #'api - testing' }
OPControllerFactory >> hasControllerFor: aModel [
	^ registrations anySatisfy: [ :each | each isForModel: aModel ]
]

{ #category : #initialization }
OPControllerFactory >> initialize [
	super initialize.
	registrations := OrderedCollection new
]

{ #category : #'api - accessing' }
OPControllerFactory >> newControllerFor: aModel [
	| controller |
	controller := (registrations detect: [ :each | each isForModel: aModel ]) controllerClass
		new.
	controller model: aModel.
	^ controller
]

{ #category : #'api - registration' }
OPControllerFactory >> register: aControllerClass forModel: aModelClass [
	self register: aControllerClass forModel: aModelClass condition: self acceptAllCondition
]

{ #category : #'api - registration' }
OPControllerFactory >> register: aControllerClass forModel: aModelClass condition: aConditionBlock [
	registrations
		add:
			(self registrationClass new
				controllerClass: aControllerClass;
				modelClass: aModelClass;
				condition: aConditionBlock)
]

{ #category : #'accessing - defaults' }
OPControllerFactory >> registrationClass [
	^ OPControllerFactoryRegistration
]
