"
I am base class for all UI - centric commands such as rename or export
"
Class {
	#name : 'OPUICommand',
	#superclass : 'Object',
	#instVars : [
		'controller'
	],
	#category : 'OpenPonk-Core-UICommands',
	#package : 'OpenPonk-Core',
	#tag : 'UICommands'
}

{ #category : 'public' }
OPUICommand class >> executeOn: anElementController [

	^ (self on: anElementController) execute
]

{ #category : 'instance creation' }
OPUICommand class >> on: anElementController [

	^ self new
		  on: anElementController;
		  yourself
]

{ #category : 'utilities' }
OPUICommand >> doAndReturnFocus: aBlock [

	| result window wasActive |
	window := controller diagramController canvasPresenter window window.
	wasActive := window isActive.
	result := aBlock value.
	window activate.
	^ result
]

{ #category : 'execute' }
OPUICommand >> execute [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPUICommand >> on: anElementController [

	controller := anElementController
]
