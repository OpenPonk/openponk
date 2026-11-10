"
Utility used during automated graph layout operations to detect cyclic dependencies (loops) within diagrams, preventing infinite loops or layout engine crashes.
"
Class {
	#name : 'OPLayoutLoopDetector',
	#superclass : 'Object',
	#instVars : [
		'boxes',
		'links',
		'processedBoxes'
	],
	#category : 'OpenPonk-Core-Layouting',
	#package : 'OpenPonk-Core',
	#tag : 'Layouting'
}

{ #category : 'actions' }
OPLayoutLoopDetector class >> haveLoopsBoxes: boxes links: links [

	^ self new
		  boxes: boxes;
		  links: links;
		  haveLoops
]

{ #category : 'accessing' }
OPLayoutLoopDetector >> boxes [

	^ boxes
]

{ #category : 'accessing' }
OPLayoutLoopDetector >> boxes: anObject [

	boxes := Array withAll: anObject
]

{ #category : 'testing' }
OPLayoutLoopDetector >> hasBox: box loopsBackTo: loopsTo [

	| toBoxes |
	(processedBoxes includes: box) ifTrue: [ ^ false ].

	toBoxes := (links
		            select: [ :each | each from = box ]
		            thenCollect: [ :each | each to ]) intersection: boxes.

	processedBoxes add: box.

	^ toBoxes anySatisfy: [ :any |
		  (loopsTo includes: any) or: [
			  self hasBox: any loopsBackTo: loopsTo , { box } ] ]
]

{ #category : 'as yet unclassified' }
OPLayoutLoopDetector >> haveLoops [

	^ boxes anySatisfy: [ :box | self hasBox: box loopsBackTo: Set new ]
]

{ #category : 'initialization' }
OPLayoutLoopDetector >> initialize [

	super initialize.

	links := Set new.
	boxes := Array new.
	processedBoxes := Set new
]

{ #category : 'accessing' }
OPLayoutLoopDetector >> links [

	^ links
]

{ #category : 'accessing' }
OPLayoutLoopDetector >> links: anObject [

	links addAll: anObject
]
