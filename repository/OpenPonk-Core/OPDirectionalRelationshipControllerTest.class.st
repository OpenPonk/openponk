"
Unit tests for OPDirectionalRelationshipController. 
Ensures that specific implementations of directed relationships properly attach and manage visual connections between shapes.
"
Class {
	#name : 'OPDirectionalRelationshipControllerTest',
	#superclass : 'OPAbstractDirectionalRelationshipControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'constants' }
OPDirectionalRelationshipControllerTest class >> diagramElementClass [

	^ OPTestEdge
]

{ #category : 'constants' }
OPDirectionalRelationshipControllerTest >> controllerClass [
	^ OPTestRelationController
]

{ #category : 'constants' }
OPDirectionalRelationshipControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'constants' }
OPDirectionalRelationshipControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : 'constants' }
OPDirectionalRelationshipControllerTest >> modelClass [
	^ OPTestRelationModel
]

{ #category : 'constants' }
OPDirectionalRelationshipControllerTest >> sourceControllerClass [

	^ OPTestEntityController 
]

{ #category : 'constants' }
OPDirectionalRelationshipControllerTest >> sourceModelClass [

	^ OPTestEntityModel
]
