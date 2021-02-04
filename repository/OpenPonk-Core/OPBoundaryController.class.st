Class {
	#name : #OPBoundaryController,
	#superclass : #OPCommonElementController,
	#traits : 'OPTResizableFigureController',
	#classTraits : 'OPTResizableFigureController classTrait',
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'as yet unclassified' }
OPBoundaryController class >> paletteItemName [
	^ #boundary
]

{ #category : #forms }
OPBoundaryController >> buildEditorForm: aForm [
	(aForm addText: 'Name')
		text: self model name;
		whenTextIsAccepted: [ :newValue | 
			self model name: newValue asString.
			self refreshFigure ]
]

{ #category : #accessing }
OPBoundaryController >> modelClass [
	^ OPBoundary
]

{ #category : #construction }
OPBoundaryController >> renderFigureIn: aView [
	self diagramController addingFigureFor: self.
	figure := OPBoundaryFigure on: self model.
	figure renderIn: aView.
	^ self diagramController addedFigureFor: self
]
