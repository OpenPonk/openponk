Class {
	#name : #OPBoundary,
	#superclass : #OPDiagramOnlyShape,
	#traits : 'OPTResizableFigureWithText',
	#classTraits : 'OPTResizableFigureWithText classTrait',
	#instVars : [
		'name',
		'positionOfMainRelativeToDragBoxes',
		'dragBoxUpdateBlocks',
		'dragBoxes'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'ston-core' }
OPBoundary class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #name )
]

{ #category : #accessing }
OPBoundary >> defaultHeight [
	^ 400
]

{ #category : #accessing }
OPBoundary >> defaultWidth [
	^ 500
]

{ #category : #initialization }
OPBoundary >> initialize [
	super initialize.
	name := ''
]

{ #category : #accessing }
OPBoundary >> name [
	^ name
]

{ #category : #accessing }
OPBoundary >> name: aString [
	name := aString
]

{ #category : #printing }
OPBoundary >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(''';
		nextPutAll: self name;
		nextPutAll: ''')'
]

{ #category : #'creating - subelements' }
OPBoundary >> renderBasicShape [

	roassalShape := RSBox new
		                color: Color transparent;
		                width: self defaultWidth;
		                height: self defaultHeight;
		                yourself.
	roassalShape borderDo: [ :border | 
		border
			color: Color gray;
			dashArray: #( 4 ) ]
]

{ #category : #'creating - subelements' }
OPBoundary >> renderShapeDetails [

	roassalShape
		@ OPRSSelectable;
		@ OPRSSelectionDraggableBorder;
		@ OPRSResizable.
	roassalShape
		when: RSExtentChangedEvent do: [ self updateFromRender ];
		when: RSPositionChangedEvent do: [ self updateFromRender ].
	self renderLabel
]

{ #category : #hooks }
OPBoundary >> text [
	^ self name
]

{ #category : #'creating - subelements' }
OPBoundary >> textOffset [

	^ 0 @ (4 + (self label height - self height / 2))
]
