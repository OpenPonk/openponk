Class {
	#name : #OPRTElementHighlighterTest,
	#superclass : #OPRTHighlighterTest,
	#category : 'OpenPonk-Roassal2-Tests'
}

{ #category : #running }
OPRTElementHighlighterTest >> setUp [
	super setUp.
	highlighter := OPRTElementHighlighter new
]

{ #category : #running }
OPRTElementHighlighterTest >> setUpModel [
	model := RTBox new element.
	view add: model
]

{ #category : #running }
OPRTElementHighlighterTest >> testHighlight [
	| overlay |
	self assert: model trachelShape callbacks isEmpty.
	highlighter highlight: model color: Color red.
	self assert: model trachelShape callbacks isNotEmpty.
	overlay := (model attributes at: highlighter attributeKey) first.
	highlighter highlight: model color: Color red.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	self assert: overlay view equals: view.
	highlighter remove.
	self assert: model trachelShape callbacks isEmpty.
	self assert: overlay view equals: nil
]

{ #category : #running }
OPRTElementHighlighterTest >> testReentrant [
	| overlay |
	highlighter highlight: model color: Color red.
	overlay := highlighter load first.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter highlight: model color: Color yellow.
	self assert: highlighter load first equals: overlay.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter remove.
	self assert: overlay view equals: nil
]
