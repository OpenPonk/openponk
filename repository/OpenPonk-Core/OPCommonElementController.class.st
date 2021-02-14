Class {
	#name : #OPCommonElementController,
	#superclass : #OPElementController,
	#instVars : [
		'announcer'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'as yet unclassified' }
OPCommonElementController class >> paletteItemName [
	^ self subclassResponsibility
]

{ #category : #construction }
OPCommonElementController >> createModelIn: aParentModel [
	self model: self modelClass new.
	^ model
]

{ #category : #testing }
OPCommonElementController >> isCommon [
	^ true
]

{ #category : #'as yet unclassified' }
OPCommonElementController >> paletteItemName [
	^ self class paletteItemName
]

{ #category : #private }
OPCommonElementController >> removeModel [
	"do nothing - common model elements are not part of any other model element"
]
