Class {
	#name : 'OPControllerCache',
	#superclass : 'Object',
	#instVars : [
		'diagramController',
		'controllerDictionary'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'instance creation' }
OPControllerCache class >> for: aDiagramController [

	^ self new
		  diagramController: aDiagramController;
		  yourself
]

{ #category : 'accessing' }
OPControllerCache >> at: anObject [

	^ self at: anObject ifAbsent: [
		  diagramController controllers errorNotFound:
			  'Controller of' , anObject asString , ' not found' ]
]

{ #category : 'accessing' }
OPControllerCache >> at: anObject ifAbsent: anAbsentBlock [

	^ self
		  at: anObject
		  ifPresent: [ :foundController | foundController ]
		  ifAbsent: anAbsentBlock
]

{ #category : 'accessing' }
OPControllerCache >> at: anObject ifPresent: aFoundBlock [

	^ self at: anObject ifPresent: aFoundBlock ifAbsent: [ "do nothing" ]
]

{ #category : 'accessing' }
OPControllerCache >> at: anObject ifPresent: aPresentBlock ifAbsent: anAbsentBlock [

	self checkSize.

	controllerDictionary at: anObject ifPresent: [ :foundController |
		(diagramController controllers includes: foundController) ifTrue: [
			^ aPresentBlock cull: foundController ] ].

	^ diagramController controllers
		  detect: [ :anyController |
		  (self keyOfController: anyController) = anObject ]
		  ifFound: [ :foundController |
			  controllerDictionary at: anObject put: foundController.
			  aPresentBlock cull: foundController ]
		  ifNone: anAbsentBlock
]

{ #category : 'private' }
OPControllerCache >> checkSize [

	controllerDictionary ifEmpty: [
		^ diagramController controllers do: [ :eachController |
			  controllerDictionary
				  at: (self keyOfController: eachController)
				  put: eachController ] ].
	diagramController controllers size * 2 > controllerDictionary size
		ifTrue: [ ^ self ].
	(controllerDictionary asSet difference: diagramController controllers)
		do: [ :eachOldController |
			controllerDictionary
				removeKey: (self keyOfController: eachOldController)
				ifAbsent: [  ] ]
]

{ #category : 'accessing' }
OPControllerCache >> diagramController: aDiagramController [

	diagramController := aDiagramController.
	controllerDictionary := Dictionary new
]

{ #category : 'hooks' }
OPControllerCache >> keyOfController: aController [

	^ self subclassResponsibility
]
