"
An OPElementLayoutTest is a test class for testing the behavior of OPElementLayout
"
Class {
	#name : #OPElementLayoutTest,
	#superclass : #TestCase,
	#instVars : [
		'layout'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #running }
OPElementLayoutTest >> setUp [
	layout := OPElementLayout withPosition: -10 @ 50 extent: 100 @ 200
]

{ #category : #tests }
OPElementLayoutTest >> testContentFromJSON [
	| newLayout |
	newLayout := NeoJSONReader
		fromString: '{"position":{"x":-10,"y":50},"extent":{"x":100,"y":200}}'.
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
		fromString: '{"position":{"x":-10,"y":50},"extent":{"x":100,"y":200}}'
		as: OPElementLayout.
	self assert: newLayout position equals: -10 @ 50.
	self assert: newLayout extent equals: 100 @ 200
]

{ #category : #tests }
OPElementLayoutTest >> testJSONWithoutExtent [
	| json newLayout |
	layout extent: nil.
	json := NeoJSONWriter toString: layout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout extent equals: nil.
	self assert: newLayout equals: layout
]

{ #category : #tests }
OPElementLayoutTest >> testRoundtripJSON [
	| json newLayout |
	json := NeoJSONWriter toString: layout.
	newLayout := NeoJSONReader fromString: json as: OPElementLayout.
	self assert: newLayout equals: layout
]

{ #category : #tests }
OPElementLayoutTest >> testToJSON [
	| json |
	json := NeoJSONWriter toString: layout.
	self
		assert: json
		equals: '{"position":{"x":-10,"y":50},"extent":{"x":100,"y":200}}'
]
