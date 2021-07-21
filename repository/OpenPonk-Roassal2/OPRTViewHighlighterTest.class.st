Class {
	#name : #OPRTViewHighlighterTest,
	#superclass : #OPRTHighlighterTest,
	#category : 'OpenPonk-Roassal2-Tests'
}

{ #category : #running }
OPRTViewHighlighterTest >> setUp [
	super setUp.
	highlighter := OPRTViewHighlighter new
]

{ #category : #running }
OPRTViewHighlighterTest >> setUpModel [
	model := view
]

{ #category : #running }
OPRTViewHighlighterTest >> testHighlight [
	model canvas color: Color blue.
	self assert: model canvas color equals: Color blue.
	highlighter highlight: model color: Color red.
	self assert: model canvas color equals: Color red.
	highlighter remove.
	self assert: model canvas color equals: Color blue
]

{ #category : #running }
OPRTViewHighlighterTest >> testReentrant [
	model canvas color: Color blue.
	self assert: model canvas color equals: Color blue.
	highlighter highlight: model color: Color red.
	self assert: model canvas color equals: Color red.
	highlighter highlight: model color: Color yellow.
	self assert: model canvas color equals: Color red.
	highlighter remove.
	self assert: model canvas color equals: Color blue
]
