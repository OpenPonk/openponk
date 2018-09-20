Class {
	#name : #OPRTViewHighlighter,
	#superclass : #OPRTHighlighter,
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #'instance creation' }
OPRTViewHighlighter class >> highlight: anElement color: aColor [
	^ self new highlight: anElement color: aColor
]

{ #category : #testing }
OPRTViewHighlighter class >> isFor: anElement [
	^ anElement isView
]

{ #category : #private }
OPRTViewHighlighter >> highlight: aView color: aColor [
	self hasStore
		ifTrue: [ ^ self ].
	model := aView.
	self store: aView canvas color.
	aView canvas color: aColor.
	aView signalUpdate
]

{ #category : #protocol }
OPRTViewHighlighter >> remove [
	self hasStore
		ifFalse: [ ^ self ].
	model canvas color: self load.
	self clearStore.
	model signalUpdate
]
