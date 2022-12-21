"
An OPElementLayoutTest is a test class for testing the behavior of OPElementLayout
"
Class {
	#name : #OPElementLayoutTest,
	#superclass : #TestCase,
	#instVars : [
		'elementLayout',
		'relationshipLayout',
		'elementLayoutJSON',
		'relationshipLayoutJSON'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #running }
OPElementLayoutTest >> setUp [
	elementLayout := OPElementLayout
		withPosition: -10 @ 50
		extent: 100 @ 200.
	relationshipLayout := OPElementLayout
		withPathFromSource: 'element'
		throughPoints:
			{(100 @ 200).
			(150 @ 200).
			(150 @ 300)}.
	elementLayoutJSON := '{"position":{"x":-10,"y":50},"extent":{"x":100,"y":200}}'.
	relationshipLayoutJSON := '{"path":{"points":[{"x":100,"y":200},{"x":150,"y":200},{"x":150,"y":300}],"source":"element"}}'
]

{ #category : #tests }
OPElementLayoutTest >> testContentFromJSON [
	| newLayout |
	newLayout := NeoJSONReader fromString: elementLayoutJSON.
	self assert: (newLayout includesKey: #position).
	self assert: ((newLayout at: #position) includesKey: #x).
	self assert: ((newLayout at: #position) at: #x) equals: -10.
	self assert: ((newLayout at: #position) includesKey: #y).
	self assert: ((newLayout at: #position) at: #y) equals: 50.
	self assert: ((newLayout at: #extent) includesKey: #x).
	self assert: ((newLayout at: #extent) at: #x) equals: 100.
	self assert: ((newLayout at: #extent) includesKey: #y).
	self assert: ((newLayout at: #extent) at: #y) equals: 200
]

{ #category : #tests }
OPElementLayoutTest >> testFromJSON [
	| newLayout |
	newLayout := NeoJSONReader
		fromString: elementLayoutJSON
		as: OPElementLayout.
	self assert: newLayout position equals: -10 @ 50.
	self assert: newLayout extent equals: 100 @ 200
]

{ #category : #tests }
OPElementLayoutTest >> testJSONWithoutExtent [
	| json newLayout |
	elementLayout extent: nil.
	json := OPJsonWriter toString: elementLayout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout extent equals: nil.
	self assert: newLayout equals: elementLayout
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipContentFromJSON [
	| newLayout path |
	newLayout := NeoJSONReader fromString: relationshipLayoutJSON.
	self assert: (newLayout includesKey: #path).
	path := newLayout at: #path.
	self assert: (path includesKey: #source).
	self assert: (path at: #source) equals: 'element'.
	self assert: (path includesKey: #points).
	self assert: (path at: #points) isCollection.
	self assert: (path at: #points) isSequenceable.
	self assert: (path at: #points) size equals: 3.
	self assert: (((path at: #points) at: 1) includesKey: #x).
	self assert: (((path at: #points) at: 1) at: #x) equals: 100.
	self assert: (((path at: #points) at: 1) includesKey: #y).
	self assert: (((path at: #points) at: 1) at: #y) equals: 200.
	self assert: (((path at: #points) at: 2) includesKey: #x).
	self assert: (((path at: #points) at: 2) at: #x) equals: 150.
	self assert: (((path at: #points) at: 2) includesKey: #y).
	self assert: (((path at: #points) at: 2) at: #y) equals: 200.
	self assert: (((path at: #points) at: 3) includesKey: #x).
	self assert: (((path at: #points) at: 3) at: #x) equals: 150.
	self assert: (((path at: #points) at: 3) includesKey: #y).
	self assert: (((path at: #points) at: 3) at: #y) equals: 300
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipFromJSON [
	| newLayout |
	newLayout := NeoJSONReader
		fromString: relationshipLayoutJSON
		as: OPElementLayout.
	self assert: newLayout path source equals: 'element'.
	self assert: newLayout path points isCollection.
	self assert: newLayout path points isSequenceable.
	self assert: newLayout path points size equals: 3.
	self assert: (newLayout path points at: 1) equals: 100 @ 200.
	self assert: (newLayout path points at: 2) equals: 150 @ 200.
	self assert: (newLayout path points at: 3) equals: 150 @ 300
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipRoundtripJSON [
	| json newLayout |
	json := OPJsonWriter toString: relationshipLayout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout equals: relationshipLayout
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipToJSON [
	| json |
	json := OPJsonWriter toString: relationshipLayout.
	self assert: json equals: relationshipLayoutJSON
]

{ #category : #tests }
OPElementLayoutTest >> testRoundtripJSON [
	| json newLayout |
	json := OPJsonWriter toString: elementLayout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout equals: elementLayout
]

{ #category : #tests }
OPElementLayoutTest >> testToJSON [
	| json |
	json := OPJsonWriter toString: elementLayout.
	self assert: json equals: elementLayoutJSON
]
