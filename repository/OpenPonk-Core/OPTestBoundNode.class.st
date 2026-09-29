"
Concrete test node used for verifying diagram element geometry, rendering, and undo/redo commands in headless environments.
"
Class {
	#name : 'OPTestBoundNode',
	#superclass : 'OPBoundNode',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'as yet unclassified' }
OPTestBoundNode >> renderBasicShape [
	^ RSBox new
		size: (self bounds ifNil: [ 80 @ 50 ] ifNotNil: #extent);
		yourself
]

{ #category : 'as yet unclassified' }
OPTestBoundNode >> selectableInteraction [
	^ OPRSSelectable highlightColorBlue
]

{ #category : 'as yet unclassified' }
OPTestBoundNode >> shouldBePositionableByUser [
	^ true
]

{ #category : 'as yet unclassified' }
OPTestBoundNode >> shouldBeResizableByUser [
	^ true
]
