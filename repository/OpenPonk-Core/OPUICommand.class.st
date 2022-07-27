"
I am base class for all UI - centric commands such as rename or export
"
Class {
	#name : #OPUICommand,
	#superclass : #Object,
	#instVars : [
		'element',
		'model'
	],
	#category : #'OpenPonk-Core-UICommands'
}

{ #category : #public }
OPUICommand class >> executeOn: anObject in: aModel [

	^ (self on: anObject in: aModel) execute
]

{ #category : #'instance creation' }
OPUICommand class >> on: anObject in: aModel [

	^ self new on: anObject in: aModel
]

{ #category : #execute }
OPUICommand >> execute [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPUICommand >> on: anElement in: aModel [

	element := anElement.
	model := aModel
]
