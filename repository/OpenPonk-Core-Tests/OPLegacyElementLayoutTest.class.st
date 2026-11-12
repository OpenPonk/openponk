"
Unit tests for OPLegacyElementLayout. 
Ensures that layout data (like extent and positions) accurately serializes and deserializes from JSON format.
"
Class {
	#name : 'OPLegacyElementLayoutTest',
	#superclass : 'TestCase',
	#instVars : [
		'elementLayout',
		'relationshipLayout',
		'elementLayoutJSON',
		'relationshipLayoutJSON'
	],
	#category : 'OpenPonk-Core-Tests-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'LegacySupport-Diagrams'
}

{ #category : 'running' }
OPLegacyElementLayoutTest >> setUp [

	super setUp.
	elementLayout := OPLegacyElementLayout
		                 withPosition: -10 @ 50
		                 extent: 100 @ 200.
	relationshipLayout := OPLegacyElementLayout
		                      withPathFromSource: 'element'
		                      throughPoints: {
				                      (100 @ 200).
				                      (150 @ 200).
				                      (150 @ 300) }.
	elementLayoutJSON := '{
	"extent" : {
		"x" : 100,
		"y" : 200
	},
	"position" : {
		"x" : -10,
		"y" : 50
	}
}'.
	relationshipLayoutJSON := '{
	"path" : {
		"points" : [
			{
				"x" : 100,
				"y" : 200
			},
			{
				"x" : 150,
				"y" : 200
			},
			{
				"x" : 150,
				"y" : 300
			}
		],
		"source" : "element"
	}
}'
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testComparisonEqualityHashAndNone [
	| noneLayout sameElementLayout otherElementLayout |
	self
		assert: OPLegacyElementLayout isDeprecated
		description: 'OPLegacyElementLayout should be marked as deprecated'.
	noneLayout := OPLegacyElementLayout none.
	self assert: noneLayout position equals: nil.
	self assert: noneLayout extent equals: nil.
	self assert: noneLayout path equals: nil.

	sameElementLayout := OPLegacyElementLayout
		withPosition: -10 @ 50
		extent: 100 @ 200.
	otherElementLayout := OPLegacyElementLayout withPosition: 5 @ 5.

	self assert: elementLayout equals: sameElementLayout.
	self assert: elementLayout hash equals: sameElementLayout hash.
	self assert: relationshipLayout hash equals: relationshipLayout path hash.
	self deny: elementLayout equals: otherElementLayout.
	self deny: elementLayout equals: relationshipLayout.

	self
		assert: elementLayout < relationshipLayout
		description: 'Node layout with position should sort before relationship layout without position'.
	self
		assert: relationshipLayout < noneLayout
		description: 'Relationship layout with path should sort before empty layout'.
	self
		assert: elementLayout <= relationshipLayout
		description: 'elementLayout should be <= relationshipLayout'.
	self
		assert: noneLayout > relationshipLayout
		description: 'noneLayout should be > relationshipLayout'.
	self
		assert: noneLayout >= elementLayout
		description: 'noneLayout should be >= elementLayout'.
	self
		assert: (relationshipLayout min: noneLayout max: elementLayout)
		equals: relationshipLayout
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testContentFromJSON [
	| newLayout |
	newLayout := NeoJSONReader fromString: elementLayoutJSON.
	self
		assert: (newLayout includesKey: #position)
		description: 'Parsed layout dictionary must include #position'.
	self
		assert: ((newLayout at: #position) includesKey: #x)
		description: 'Position dictionary must include #x'.
	self assert: ((newLayout at: #position) at: #x) equals: -10.
	self
		assert: ((newLayout at: #position) includesKey: #y)
		description: 'Position dictionary must include #y'.
	self assert: ((newLayout at: #position) at: #y) equals: 50.
	self
		assert: (newLayout includesKey: #extent)
		description: 'Parsed layout dictionary must include #extent'.
	self
		assert: ((newLayout at: #extent) includesKey: #x)
		description: 'Extent dictionary must include #x'.
	self assert: ((newLayout at: #extent) at: #x) equals: 100.
	self
		assert: ((newLayout at: #extent) includesKey: #y)
		description: 'Extent dictionary must include #y'.
	self assert: ((newLayout at: #extent) at: #y) equals: 200
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testFromJSON [
	| newLayout |
	newLayout := NeoJSONReader
		fromString: elementLayoutJSON
		as: OPLegacyElementLayout.
	self assert: newLayout position equals: -10 @ 50.
	self assert: newLayout extent equals: 100 @ 200
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testJSONWithoutExtent [
	| json newLayout |
	elementLayout extent: nil.
	json := OPJsonWriter toString: elementLayout.
	newLayout := NeoJSONReader fromString: json as: OPLegacyElementLayout.
	self assert: newLayout extent equals: nil.
	self assert: newLayout equals: elementLayout
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testPrintOnAndApplyToDiagramElement [
	| canvas node posOnlyLayout sourceNode targetNode edge |
	self
		assert: (OPLegacyElementLayout none printString includesSubstring: 'OPLegacyElementLayout')
		description: 'Empty layout printString should contain class name'.
	self
		assert: (relationshipLayout printString includesSubstring: '(relationship)')
		description: 'Relationship layout printString should include (relationship)'.
	posOnlyLayout := OPLegacyElementLayout withPosition: 15 @ 25.
	self
		assert: (posOnlyLayout printString includesSubstring: '15@25')
		description: 'Position-only layout printString should include position'.
	self
		assert: (elementLayout printString includesSubstring: '(-10@50) (100@200)')
		description: 'Full node layout printString should include position and extent'.

	canvas := RSCanvas new.
	node := OPTestBoundNode new.
	node renderIn: canvas.
	elementLayout applyToDiagramElement: node.
	self assert: node position equals: -10 @ 50.
	self assert: node extent equals: 100 @ 200.

	posOnlyLayout applyToDiagramElement: node.
	self assert: node position equals: 15 @ 25.
	self assert: node extent equals: 100 @ 200.

	sourceNode := OPTestBoundNode new
		bounds: (OPNodeBounds withPosition: 100 @ 200 extent: 20 @ 20);
		renderIn: canvas;
		yourself.
	targetNode := OPTestBoundNode new
		bounds: (OPNodeBounds withPosition: 150 @ 300 extent: 20 @ 20);
		renderIn: canvas;
		yourself.
	edge := OPTestEdge new
		source: sourceNode;
		target: targetNode;
		renderIn: canvas;
		yourself.
	relationshipLayout applyToDiagramElement: edge.
	self assert: edge innerWaypoints asArray equals: { 150 @ 200 }
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testRelationshipContentFromJSON [
	| newLayout path |
	newLayout := NeoJSONReader fromString: relationshipLayoutJSON.
	self
		assert: (newLayout includesKey: #path)
		description: 'Relationship layout dictionary must include #path'.
	path := newLayout at: #path.
	self
		assert: (path includesKey: #source)
		description: 'Path dictionary must include #source'.
	self assert: (path at: #source) equals: 'element'.
	self
		assert: (path includesKey: #points)
		description: 'Path dictionary must include #points'.
	self
		assert: (path at: #points) isCollection
		description: 'Path points must be a collection'.
	self
		assert: (path at: #points) isSequenceable
		description: 'Path points must be sequenceable'.
	self assert: (path at: #points) size equals: 3.
	self
		assert: (((path at: #points) at: 1) includesKey: #x)
		description: 'First point must include #x'.
	self assert: (((path at: #points) at: 1) at: #x) equals: 100.
	self
		assert: (((path at: #points) at: 1) includesKey: #y)
		description: 'First point must include #y'.
	self assert: (((path at: #points) at: 1) at: #y) equals: 200.
	self
		assert: (((path at: #points) at: 2) includesKey: #x)
		description: 'Second point must include #x'.
	self assert: (((path at: #points) at: 2) at: #x) equals: 150.
	self
		assert: (((path at: #points) at: 2) includesKey: #y)
		description: 'Second point must include #y'.
	self assert: (((path at: #points) at: 2) at: #y) equals: 200.
	self
		assert: (((path at: #points) at: 3) includesKey: #x)
		description: 'Third point must include #x'.
	self assert: (((path at: #points) at: 3) at: #x) equals: 150.
	self
		assert: (((path at: #points) at: 3) includesKey: #y)
		description: 'Third point must include #y'.
	self assert: (((path at: #points) at: 3) at: #y) equals: 300
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testRelationshipFromJSON [
	| newLayout |
	newLayout := NeoJSONReader
		fromString: relationshipLayoutJSON
		as: OPLegacyElementLayout.
	self assert: newLayout path source equals: 'element'.
	self
		assert: newLayout path points isCollection
		description: 'Deserialized path points must be a collection'.
	self
		assert: newLayout path points isSequenceable
		description: 'Deserialized path points must be sequenceable'.
	self assert: newLayout path points size equals: 3.
	self assert: (newLayout path points at: 1) equals: 100 @ 200.
	self assert: (newLayout path points at: 2) equals: 150 @ 200.
	self assert: (newLayout path points at: 3) equals: 150 @ 300
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testRelationshipRoundtripJSON [
	| json newLayout |
	json := OPJsonWriter toString: relationshipLayout.
	newLayout := NeoJSONReader fromString: json as: OPLegacyElementLayout.
	self assert: newLayout equals: relationshipLayout
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testRelationshipToJSON [
	| json |
	json := OPJsonWriter toString: relationshipLayout.
	self assert: json equals: relationshipLayoutJSON withUnixLineEndings
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testRoundtripJSON [
	| json newLayout |
	json := OPJsonWriter toString: elementLayout.
	newLayout := NeoJSONReader fromString: json as: OPLegacyElementLayout.
	self assert: newLayout equals: elementLayout
]

{ #category : 'tests' }
OPLegacyElementLayoutTest >> testToJSON [
	| json |
	json := OPJsonWriter toString: elementLayout.
	self assert: json equals: elementLayoutJSON withUnixLineEndings
]
