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

{ #category : 'connecting' }
OPBoundaryController >> addAsTargetFor: aController [

	^ self diagramController addAsTargetFor: aController
]

{ #category : 'forms' }
OPBoundaryController >> buildEditorForm: aForm [

	(aForm addText: 'Name')
		text: self diagramElement name;
		whenTextChangedDo: [ :newValue | 
			self diagramElement name: newValue asString.
			self diagramElement updateText ]
]

{ #category : 'connecting' }
OPBoundaryController >> canBeTargetFor: aController [
	^ self diagramController canBeTargetFor: aController
]

{ #category : 'ui-hooks' }
OPBoundaryController >> creationUICommandClass [

	^ OPRenameElementCommand
]

{ #category : 'accessing' }
OPBoundaryController >> propertiesTarget [
	^ self
]
