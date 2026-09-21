"
I represent an undoable command that updates a visual style property (e.g. fill color, stroke) of a diagram element.
"
Class {
	#name : 'OPChangeDiagramElementStylePropertyCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'element',
		'property',
		'oldValue',
		'newValue',
		'hadLocalProperty'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'as yet unclassified' }
OPChangeDiagramElementStylePropertyCommand class >> element: anElement property: aSymbol value: aValue [
	^ self new
		element: anElement
		property: aSymbol
		value: aValue
]

{ #category : 'accessing' }
OPChangeDiagramElementStylePropertyCommand >> element [
	^ element
]

{ #category : 'accessing' }
OPChangeDiagramElementStylePropertyCommand >> element: anElement property: aSymbol value: aValue [
	element := anElement.
	property := aSymbol asSymbol.
	newValue := aValue.
	hadLocalProperty := element localStyle isNotNil and: [ 
		                    element localStyle includesKey: property ].
	oldValue := element stylePropertyNamed: property ifAbsent: [ nil ]
]

{ #category : 'executing' }
OPChangeDiagramElementStylePropertyCommand >> execute [
	element stylePropertyNamed: property put: newValue
]

{ #category : 'accessing' }
OPChangeDiagramElementStylePropertyCommand >> newValue [
	^ newValue
]

{ #category : 'accessing' }
OPChangeDiagramElementStylePropertyCommand >> oldValue [
	^ oldValue
]

{ #category : 'accessing' }
OPChangeDiagramElementStylePropertyCommand >> property [
	^ property
]

{ #category : 'executing' }
OPChangeDiagramElementStylePropertyCommand >> redo [
	self execute
]

{ #category : 'executing' }
OPChangeDiagramElementStylePropertyCommand >> undo [
	hadLocalProperty
		ifTrue: [ element stylePropertyNamed: property put: oldValue ]
		ifFalse: [ element removeLocalStylePropertyNamed: property ]
]
