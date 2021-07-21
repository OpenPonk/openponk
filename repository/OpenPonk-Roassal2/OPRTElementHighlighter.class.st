Class {
	#name : #OPRTElementHighlighter,
	#superclass : #OPRTHighlighter,
	#instVars : [
		'noBorder'
	],
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #'instance creation' }
OPRTElementHighlighter class >> highlight: anElement color: aColor [
	^ self new highlight: anElement color: aColor
]

{ #category : #testing }
OPRTElementHighlighter class >> isFor: anElement [
	^ anElement isElement
]

{ #category : #private }
OPRTElementHighlighter >> highlight: anElement color: aColor [
	| shape overlay originalCallbacks newCallbacks |
	self hasStore
		ifTrue: [ ^ self ].
	model := anElement.
	shape := RTBox new.
	model shape class = RTRoundedBox
		ifTrue: [ (shape := RTRoundedBox new) borderRadius: (model shape borderRadiusFor: model) ].
	model shape class = RTEllipse
		ifTrue: [ shape := RTEllipse new ].
	overlay := shape
		color: (aColor alpha: 0.2);
		borderColor: (aColor alpha: 0.2);
		element.
	noBorder
		ifTrue: [ overlay trachelShape strokeWidth: 0.
			overlay trachelShape strokePaint: Color red ].
	originalCallbacks := model trachelShape callbacks copy.
	OPRTElementsConstraint keepExtentOf: overlay like: model plus: 3 @ 3.
	TRConstraint stick: overlay onTheCenterOf: model.
	newCallbacks := model trachelShape callbacks \ originalCallbacks.
	self store: (Array with: overlay with: newCallbacks).
	model view add: overlay.
	model view signalUpdate
]

{ #category : #initialization }
OPRTElementHighlighter >> initialize [
	super initialize.
	noBorder := false
]

{ #category : #'as yet unclassified' }
OPRTElementHighlighter >> noBorder [
	noBorder := true
]

{ #category : #protocol }
OPRTElementHighlighter >> remove [
	| overlayAndCallbacks |
	self hasStore
		ifFalse: [ ^ self ].
	overlayAndCallbacks := self load.
	overlayAndCallbacks second
		do: [ :each | model trachelShape removeCallback: each ifAbsent: [  ] ].
	self clearStore.
	overlayAndCallbacks first remove.
	model view signalUpdate
]
