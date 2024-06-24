Class {
	#name : 'OPDirectionalRelationshipControllerTest',
	#superclass : 'OPAbstractDirectionalRelationshipControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPDirectionalRelationshipControllerTest >> controllerClass [
	^ OPTestRelationController
]

{ #category : 'accessing' }
OPDirectionalRelationshipControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'construction' }
OPDirectionalRelationshipControllerTest >> diagramElementClass [

	^ OPTestEdge
]

{ #category : 'accessing' }
OPDirectionalRelationshipControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : 'accessing' }
OPDirectionalRelationshipControllerTest >> modelClass [
	^ OPTestRelationModel
]

{ #category : 'accessing' }
OPDirectionalRelationshipControllerTest >> sourceControllerClass [

	^ OPTestEntityController 
]

{ #category : 'accessing' }
OPDirectionalRelationshipControllerTest >> sourceModelClass [

	^ OPTestEntityModel
]
