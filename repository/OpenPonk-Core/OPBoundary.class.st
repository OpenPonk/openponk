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

{ #category : #'creating - subelements' }
OPBoundary >> addSelectionDraggableInteraction [

	roassalShape
	@ OPRSSelectionDraggableBorder thatAlsoDragsContainedShapes
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

	^ RSBox new
		  color: Color transparent;
		  width: self defaultWidth;
		  height: self defaultHeight;
		  borderDo: [ :border | 
			  border
				  color: Color gray;
				  dashArray: #( 4 ) ];
		  yourself
]

{ #category : #'creating - subelements' }
OPBoundary >> renderShapeDetails [

	super renderShapeDetails.
	self renderLabel
]

{ #category : #'creating - subelements' }
OPBoundary >> selectableInteraction [

	^ OPRSSelectable
]

{ #category : #'creating - subelements' }
OPBoundary >> setupLabelLocation: aLocation [

	aLocation
		top;
		center;
		inner
]

{ #category : #interactions }
OPBoundary >> shouldBePositionableByUser [

	^ true
]

{ #category : #interactions }
OPBoundary >> shouldBeResizableByUser [

	^ true
]

{ #category : #hooks }
OPBoundary >> text [
	^ self name
]
