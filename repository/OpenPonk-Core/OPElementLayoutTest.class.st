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
		withPathPoints:
			{(100 @ 200).
			(150 @ 200).
			(150 @ 300)}.
	elementLayoutJSON := '{"position":{"x":-10,"y":50},"extent":{"x":100,"y":200}}'.
	relationshipLayoutJSON := '{"pathPoints":[{"x":100,"y":200},{"x":150,"y":200},{"x":150,"y":300}]}'
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
	json := NeoJSONWriter toString: elementLayout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout extent equals: nil.
	self assert: newLayout equals: elementLayout
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipContentFromJSON [
	| newLayout |
	newLayout := NeoJSONReader fromString: relationshipLayoutJSON.
	self assert: (newLayout includesKey: #pathPoints).
	self assert: (newLayout at: #pathPoints) isCollection.
	self assert: (newLayout at: #pathPoints) isSequenceable.
	self assert: (newLayout at: #pathPoints) size equals: 3.
	self assert: (((newLayout at: #pathPoints) at: 1) includesKey: #x).
	self assert: (((newLayout at: #pathPoints) at: 1) at: #x) equals: 100.
	self assert: (((newLayout at: #pathPoints) at: 1) includesKey: #y).
	self assert: (((newLayout at: #pathPoints) at: 1) at: #y) equals: 200.
	self assert: (((newLayout at: #pathPoints) at: 2) includesKey: #x).
	self assert: (((newLayout at: #pathPoints) at: 2) at: #x) equals: 150.
	self assert: (((newLayout at: #pathPoints) at: 2) includesKey: #y).
	self assert: (((newLayout at: #pathPoints) at: 2) at: #y) equals: 200.
	self assert: (((newLayout at: #pathPoints) at: 3) includesKey: #x).
	self assert: (((newLayout at: #pathPoints) at: 3) at: #x) equals: 150.
	self assert: (((newLayout at: #pathPoints) at: 3) includesKey: #y).
	self assert: (((newLayout at: #pathPoints) at: 3) at: #y) equals: 300
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipFromJSON [
	| newLayout |
	newLayout := NeoJSONReader
		fromString: relationshipLayoutJSON
		as: OPElementLayout.
	self assert: newLayout pathPoints isCollection.
	self assert: newLayout pathPoints isSequenceable.
	self assert: newLayout pathPoints size equals: 3.
	self assert: (newLayout pathPoints at: 1) equals: 100 @ 200.
	self assert: (newLayout pathPoints at: 2) equals: 150 @ 200.
	self assert: (newLayout pathPoints at: 3) equals: 150 @ 300
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipRoundtripJSON [
	| json newLayout |
	json := NeoJSONWriter toString: relationshipLayout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout equals: relationshipLayout
]

{ #category : #tests }
OPElementLayoutTest >> testRelationshipToJSON [
	| json |
	json := NeoJSONWriter toString: relationshipLayout.
	self assert: json equals: relationshipLayoutJSON
]

{ #category : #tests }
OPElementLayoutTest >> testRoundtripJSON [
	| json newLayout |
	json := NeoJSONWriter toString: elementLayout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout equals: elementLayout
]

{ #category : #tests }
OPElementLayoutTest >> testToJSON [
	| json |
	json := NeoJSONWriter toString: elementLayout.
	self assert: json equals: elementLayoutJSON
]
