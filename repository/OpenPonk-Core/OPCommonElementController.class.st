Class {
	#name : #OPCommonElementController,
	#superclass : #OPElementController,
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'as yet unclassified' }
OPCommonElementController class >> paletteItemName [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPCommonElementController >> paletteItemName [
	^ self class paletteItemName
]
