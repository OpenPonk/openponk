"
Controller managing OPBoundary diagram elements. 
Operates as a diagram-only controller without a corresponding domain model, and manages interactions such as user-driven resizing for visual boundaries.
"
Class {
	#name : 'OPBoundaryController',
	#superclass : 'OPDiagramOnlyController',
	#traits : 'OPTResizableFigureController',
	#classTraits : 'OPTResizableFigureController classTrait',
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}

{ #category : 'construction' }
OPBoundaryController class >> diagramElementClass [
	^ OPBoundary
]

{ #category : 'accessing' }
OPBoundaryController class >> modelClass [

	^ OPBoundary
]

{ #category : 'constants' }
OPBoundaryController class >> paletteItemName [
	^ #boundary
]

{ #category : 'accessing' }
OPBoundaryController class >> viewModelClass [

	^ OPBoundaryViewModel
]

{ #category : 'user interface' }
OPBoundaryController >> addAsTargetFor: aController [
	^ self addAsTargetFor: aController onPosition: nil
]

{ #category : 'user interface' }
OPBoundaryController >> addAsTargetFor: aController onPosition: aPoint [
	^ self diagramController addAsTargetFor: aController onPosition: aPoint
]

{ #category : 'connecting' }
OPBoundaryController >> canBeTargetFor: aController [
	^ self diagramController canBeTargetFor: aController
]
