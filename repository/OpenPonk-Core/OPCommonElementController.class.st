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

{ #category : #accessing }
OPCommonElementController >> ensureDiagramElement [

	diagramElement ifNil: [ self createDiagramElement ].
	^ diagramElement
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
OPCommonElementController >> model: aModel [

	self diagramElement: aModel
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
