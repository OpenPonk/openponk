"
Specialization of OPModelHandlerFactory dedicated to instantiating diagram controllers. 
Maps domain model classes to their respective visual controller classes within a diagram context.
"
Class {
	#name : 'OPControllerFactory',
	#superclass : 'OPModelHandlerFactory',
	#instVars : [
		'diagramController'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'instance creation' }
OPControllerFactory class >> withCommonElements [
	^ self new registerCommonElements
]

{ #category : 'instance creation' }
OPControllerFactory class >> withCommonElementsFor: aDiagramController [

	^ self new
		  diagramController: aDiagramController;
		  registerCommonElements
]

{ #category : 'accessing' }
OPControllerFactory >> diagramController: aDiagramController [

	diagramController := aDiagramController
]

{ #category : 'hooks' }
OPControllerFactory >> handlerKindName [

	^ 'controller'
]

{ #category : 'api - testing' }
OPControllerFactory >> hasControllerFor: aModel [

	^ self hasHandlerFor: aModel
]

{ #category : 'api - accessing' }
OPControllerFactory >> newControllerFor: aModel [

	^ self newHandlerFor: aModel
]

{ #category : 'hooks' }
OPControllerFactory >> registerCommonElements [
	OPDiagramOnlyController
		allSubclassesDo: [ :each | self register: each forModel: each modelClass ]
]

{ #category : 'api - accessing' }
OPControllerFactory >> setupHandler: aHandler withModel: aModel [

	aHandler viewModelRegistry: diagramController viewModelRegistry.
	super setupHandler: aHandler withModel: aModel
]
