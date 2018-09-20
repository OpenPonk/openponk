"
I am a smart line that adds a temporary line to the view with one end attached to an element and second following the mouse cursor.

Useful for providing live feedback when creating edges.
"
Class {
	#name : #OPInteractiveLine,
	#superclass : #Object,
	#instVars : [
		'source',
		'view',
		'mouseBox',
		'line',
		'running',
		'lineBuilder',
		'moveSubscription'
	],
	#category : 'OpenPonk-Roassal2-Interactivity'
}

{ #category : #accessing }
OPInteractiveLine >> from: anElement [
	source := anElement
]

{ #category : #initialization }
OPInteractiveLine >> initialize [
	super initialize.
	running := false
]

{ #category : #accessing }
OPInteractiveLine >> lineBuilder: aBlock [
	lineBuilder := aBlock
]

{ #category : #accessing }
OPInteractiveLine >> remove [
	running
		ifTrue: [ 
			running := false.
			view announcer unsubscribe: moveSubscription.
			mouseBox remove.
			view signalUpdate ]
]

{ #category : #hooks }
OPInteractiveLine >> renderIn: aView [
	view := aView.

	mouseBox := RTBox new
		size: 0;
		color: Color transparent;
		element.

	line := lineBuilder value: source value: mouseBox.
"	line shape color: Color veryLightGray."

	mouseBox translateTo: source position.
	aView add: mouseBox.

	aView add: line.
	line update.
	aView signalUpdate.

	moveSubscription := aView announcer
		when: TRMouseMove
		do: [ :event | 
			mouseBox translateTo: event position.
			aView signalUpdate ].

	running := true
]
