"
I am base class for all UI - centric commands such as rename or export
"
Class {
	#name : #OPUICommand,
	#superclass : #Object,
	#instVars : [
		'controller'
	],
	#category : #'OpenPonk-Core-UICommands'
}

{ #category : #public }
OPUICommand class >> executeOn: anElementController [

	^ (self on: anElementController) execute
]

{ #category : #'instance creation' }
OPUICommand class >> on: anElementController [

	^ self new
		  on: anElementController;
		  yourself
]

{ #category : #execute }
OPUICommand >> execute [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPUICommand >> on: anElementController [

	controller := anElementController
]
