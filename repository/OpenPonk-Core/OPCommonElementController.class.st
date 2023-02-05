Class {
	#name : #OPCommonElementController,
	#superclass : #OPElementController,
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'as yet unclassified' }
OPCommonElementController class >> paletteItemName [
	^ self subclassResponsibility
]

{ #category : #construction }
OPCommonElementController >> createModelIn: aParentModel [

	"do nothing - common model elements are not part of any model"

	^ nil
]

{ #category : #announcements }
OPCommonElementController >> internalSubscribeTo: aModel [

	"do nothing"

	
]

{ #category : #testing }
OPCommonElementController >> isCommon [
	^ true
]

{ #category : #accessing }
OPCommonElementController >> model [

	^ self diagramElement
]

{ #category : #accessing }
OPCommonElementController >> modelClass [

	^ self diagramElementClass 
]

{ #category : #'as yet unclassified' }
OPCommonElementController >> paletteItemName [
	^ self class paletteItemName
]

{ #category : #private }
OPCommonElementController >> removeModel [

	"do nothing - common model elements are not part of any model"

	
]
