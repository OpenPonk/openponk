Class {
	#name : #OPRTEdgeHighlighterTest,
	#superclass : #OPRTHighlighterTest,
	#category : 'OpenPonk-Roassal2-Tests'
}

{ #category : #running }
OPRTEdgeHighlighterTest >> setUp [
	super setUp.
	highlighter := OPRTEdgeHighlighter new
]

{ #category : #running }
OPRTEdgeHighlighterTest >> setUpModel [
	| endPoint |
	endPoint := RTBox new element.
	view add: endPoint.
	model := RTLine new
		color: Color blue;
		edgeFrom: endPoint to: endPoint.
	view add: model
]

{ #category : #tests }
OPRTEdgeHighlighterTest >> testHighlight [
	self assert: (model shape colorFor: model) equals: Color blue.
	highlighter highlight: model color: Color red.
	self assert: (model shape colorFor: model) equals: Color red.
	highlighter remove.
	self assert: (model shape colorFor: model) equals: Color blue
]

{ #category : #tests }
OPRTEdgeHighlighterTest >> testReentrant [
	self assert: (model shape colorFor: model) equals: Color blue.
	highlighter highlight: model color: Color red.
	self assert: (model shape colorFor: model) equals: Color red.
	highlighter highlight: model color: Color yellow.
	self assert: (model shape colorFor: model) equals: Color red.
	highlighter remove.
	self assert: (model shape colorFor: model) equals: Color blue
]
