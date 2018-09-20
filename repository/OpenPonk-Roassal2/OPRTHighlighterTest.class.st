Class {
	#name : #OPRTHighlighterTest,
	#superclass : #TestCase,
	#instVars : [
		'highlighter',
		'model',
		'view'
	],
	#category : 'OpenPonk-Roassal2-Tests'
}

{ #category : #running }
OPRTHighlighterTest class >> isAbstract [
	^ self = OPRTHighlighterTest
]

{ #category : #running }
OPRTHighlighterTest >> setUp [
	view := RTView new.
	self setUpModel
]

{ #category : #running }
OPRTHighlighterTest >> setUpModel [
	^ self subclassResponsibility
]

{ #category : #tests }
OPRTHighlighterTest >> testIsFor [
	self assert: (highlighter class isFor: model)
]

{ #category : #tests }
OPRTHighlighterTest >> testRemove [
	self deny: highlighter hasStore.
	highlighter highlight: model color: Color red.
	self assert: highlighter hasStore.
	highlighter remove.
	self deny: highlighter hasStore
]
