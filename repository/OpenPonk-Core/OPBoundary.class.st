"
Visual boundary (or visual grouping box) element in a diagram. 
As a diagram-only shape, groups visual elements spatially on the canvas without acting as a structural container in the underlying domain model.
"
Class {
	#name : 'OPBoundary',
	#superclass : 'OPDiagramOnlyShapeWithText',
	#traits : 'OPTColoredAsFillAndBorderColoredAsStroke',
	#classTraits : 'OPTColoredAsFillAndBorderColoredAsStroke classTrait',
	#instVars : [
		'name'
	],
	#category : 'OpenPonk-Core-DiagramOnlyElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramOnlyElements'
}

{ #category : 'ston-core' }
OPBoundary class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #name )
]

{ #category : 'interactions' }
OPBoundary >> addSelectionDraggableInteraction [

	roassalShape
	@ OPRSSelectionDraggableBorder thatAlsoDragsContainedShapes
]

{ #category : 'accessing' }
OPBoundary >> defaultFillColor [

	^ Color transparent
]

{ #category : 'accessing' }
OPBoundary >> defaultHeight [
	^ 400
]

{ #category : 'accessing' }
OPBoundary >> defaultStrokeColor [

	^ Color gray slightlyDarker
]

{ #category : 'accessing' }
OPBoundary >> defaultWidth [
	^ 500
]

{ #category : 'initialization' }
OPBoundary >> initialize [

	super initialize.
	name := ''.
	self
		when: OPElementTextAttributeChanged
		send: #updateRenderFromSelf
		to: self
]

{ #category : 'accessing' }
OPBoundary >> name [
	^ name
]

{ #category : 'accessing' }
OPBoundary >> name: aString [
	name := aString
]

{ #category : 'printing' }
OPBoundary >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(''';
		nextPutAll: self name;
		nextPutAll: ''')'
]

{ #category : 'rendering' }
OPBoundary >> renderBasicShape [

	^ RSBox new
		  width: self defaultWidth;
		  height: self defaultHeight;
		  borderDo: [ :border | border dashArray: #( 4 ) ];
		  yourself
]

{ #category : 'interactions' }
OPBoundary >> selectableInteraction [

	^ OPRSSelectable
]

{ #category : 'creating - subelements' }
OPBoundary >> setupLabelLocation: aLocation [

	aLocation
		top;
		center;
		inner
]

{ #category : 'interactions' }
OPBoundary >> shouldBeResizableByUser [

	^ true
]

{ #category : 'accessing' }
OPBoundary >> text [
	^ self name
]
