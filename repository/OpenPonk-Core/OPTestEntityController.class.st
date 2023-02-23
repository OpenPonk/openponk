"
I am a mock class for testing ""regular"" model controllers.
"
Class {
	#name : #OPTestEntityController,
	#superclass : #OPElementController,
	#category : #'OpenPonk-Core-Controllers - Tests'
}

{ #category : #testing }
OPTestEntityController >> canBeSourceFor: aController [
	^ aController modelClass = OPTestRelationModel
]

{ #category : #testing }
OPTestEntityController >> canBeTargetFor: aController [
	^ aController modelClass = OPTestRelationModel
]

{ #category : #connecting }
OPTestEntityController >> modelAsParent [
	^ self diagramController model
]

{ #category : #accessing }
OPTestEntityController >> modelClass [
	^ OPTestEntityModel
]

{ #category : #destruction }
OPTestEntityController >> removeModel [
	| ownerModel |
	ownerModel := self diagramController model.
	ownerModel entities remove: self model
]

{ #category : #construction }
OPTestEntityController >> renderFigureIn: aView [
	self diagramController willRender: self.
	figure := RTBox new size: 50; elementOn: self model.
	aView add: figure.
	^ self diagramController rendered: self
]
