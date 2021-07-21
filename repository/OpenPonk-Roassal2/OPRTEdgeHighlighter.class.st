Class {
	#name : #OPRTEdgeHighlighter,
	#superclass : #OPRTHighlighter,
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #'instance creation' }
OPRTEdgeHighlighter class >> highlight: anElement color: aColor [
	^ self new highlight: anElement color: aColor
]

{ #category : #testing }
OPRTEdgeHighlighter class >> isFor: anElement [
	^ anElement isEdge
		and: [ self environment
				at: #OPUmlEdge
				ifPresent: [ :cls | (anElement model isKindOf: cls) not ]
				ifAbsent: [ true ] ]
]

{ #category : #private }
OPRTEdgeHighlighter >> highlight: anEdge color: aColor [
	self hasStore
		ifTrue: [ ^ self ].
	model := anEdge.
	self store: (model shape colorFor: model).
	model shape color: aColor.
	model update.
	model view signalUpdate
]

{ #category : #protocol }
OPRTEdgeHighlighter >> remove [
	self hasStore
		ifFalse: [ ^ self ].
	model shape color: self load.
	self clearStore.
	model update.
	model view signalUpdate
]
