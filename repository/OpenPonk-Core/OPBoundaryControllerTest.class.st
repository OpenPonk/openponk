Class {
	#name : 'OPBoundaryControllerTest',
	#superclass : 'OPDiagramOnlyControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPBoundaryControllerTest >> controllerClass [

	^ OPBoundaryController
]

{ #category : 'accessing' }
OPBoundaryControllerTest >> diagramControllerClass [

	^ OPTestDiagramController
]

{ #category : 'construction' }
OPBoundaryControllerTest >> diagramElementClass [

	^ OPBoundary
]

{ #category : 'accessing' }
OPBoundaryControllerTest >> diagramModelClass [

	^ OPTestContainerModel
]

{ #category : 'accessing' }
OPBoundaryControllerTest >> modelClass [

	^ self diagramElementClass
]
