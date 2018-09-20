Class {
	#name : #DCOCNode,
	#superclass : #DCGTNode,
	#instVars : [
		'element'
	],
	#category : 'DynaCASE-Layouting-OCR'
}

{ #category : #'as yet unclassified' }
DCOCNode >> direction [
	^ self element encompassingRectangle sideNearestTo: self model
]

{ #category : #'as yet unclassified' }
DCOCNode >> dirnsFrom: previousNode [
	| res |
	res := Set new.
	self model y < previousNode model y
		ifTrue: [ res add: #top ].
	self model y > previousNode model y
		ifTrue: [ res add: #bottom ].
	self model x > previousNode model x
		ifTrue: [ res add: #left ].
	self model x < previousNode model x
		ifTrue: [ res add: #right ].
	^ res
]

{ #category : #'as yet unclassified' }
DCOCNode >> distanceTo: aNode [
	"Manhattan distance between two nodes."

	^ (self model x - aNode model x) abs + (self model y - aNode model y) abs
]

{ #category : #accessing }
DCOCNode >> element [
	^ element
]

{ #category : #accessing }
DCOCNode >> element: anElement [
	element := anElement
]

{ #category : #'as yet unclassified' }
DCOCNode >> leftOf: aDirection [
	^ {(#top -> #left).
	(#left -> #bottom).
	(#bottom -> #right).
	(#right -> #top)} asDictionary at: aDirection
]

{ #category : #'as yet unclassified' }
DCOCNode >> reverseOf: aDirection [
	^ {(#top -> #bottom).
	(#right -> #left).
	(#bottom -> #top).
	(#left -> #right)} asDictionary at: aDirection
]

{ #category : #'as yet unclassified' }
DCOCNode >> rightOf: aDirection [
	^ {(#top -> #right).
	(#right -> #bottom).
	(#bottom -> #left).
	(#left -> #top)} asDictionary at: aDirection
]
