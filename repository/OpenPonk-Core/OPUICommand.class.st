"
I am base class for all UI - centric commands such as rename or export
"
Class {
	#name : #OPUICommand,
	#superclass : #Object,
	#instVars : [
		'model'
	],
	#category : #'OpenPonk-Core-UICommands'
}

{ #category : #public }
OPUICommand class >> executeOn: anObject [
	^ self new
		on: anObject;
		execute
]

{ #category : #'instance creation' }
OPUICommand class >> on: anObject [
	^ self new on: anObject
]

{ #category : #execute }
OPUICommand >> execute [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPUICommand >> on: aModel [
	model := aModel
]
