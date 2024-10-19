Class {
	#name : 'OPBoundaryController',
	#superclass : 'OPCommonElementController',
	#traits : 'OPTResizableFigureController',
	#classTraits : 'OPTResizableFigureController classTrait',
	#category : 'OpenPonk-Core-CommonElements',
	#package : 'OpenPonk-Core',
	#tag : 'CommonElements'
}

{ #category : 'as yet unclassified' }
OPBoundaryController class >> paletteItemName [
	^ #boundary
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

{ #category : 'construction' }
OPBoundaryController >> diagramElementClass [

	^ OPBoundary
]
