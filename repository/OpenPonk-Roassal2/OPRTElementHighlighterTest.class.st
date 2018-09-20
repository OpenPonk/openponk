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
	highlighter highlight: model color: Color red.
	overlay := model attributes at: highlighter attributeKey.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	self assert: overlay view equals: view.
	highlighter remove.
	self assert: overlay view equals: nil
]

{ #category : #running }
OPRTElementHighlighterTest >> testReentrant [
	| overlay |
	highlighter highlight: model color: Color red.
	overlay := highlighter load.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter highlight: model color: Color yellow.
	self assert: highlighter load equals: overlay.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter remove.
	self assert: overlay view equals: nil
]
