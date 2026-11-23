"
Verifies conditional drag gating in OPRSConditionallyDraggable and no-op behavior in OPRSNoInteraction.
"
Class {
	#name : 'OPRSConditionallyDraggableTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'tests' }
OPRSConditionallyDraggableTest >> testDefaultConditionAllowsDragAndFalseConditionBlocksDrag [

	| canvas allowedBox blockedBox |
	canvas := RSCanvas new.
	allowedBox := RSBox new
		              size: 20;
		              translateTo: 10 @ 10;
		              yourself.
	blockedBox := RSBox new
		              size: 20;
		              translateTo: 10 @ 10;
		              yourself.
	canvas
		add: allowedBox;
		add: blockedBox.
	allowedBox @ OPRSConditionallyDraggable new.
	blockedBox @ (OPRSConditionallyDraggable onCondition: [ false ]).
	allowedBox announce: (RSMouseDragging new
			 shape: allowedBox;
			 canvas: canvas;
			 step: 15 @ 20;
			 yourself).
	blockedBox announce: (RSMouseDragging new
			 shape: blockedBox;
			 canvas: canvas;
			 step: 15 @ 20;
			 yourself).
	self assert: allowedBox position equals: 25 @ 30.
	self assert: blockedBox position equals: 10 @ 10
]

{ #category : 'tests' }
OPRSConditionallyDraggableTest >> testNoInteractionDoesNothingOnShape [

	| box |
	box := RSBox new
		       extent: 40 @ 20;
		       translateTo: 15 @ 25;
		       yourself.
	box @ OPRSNoInteraction new.
	self assert: box extent equals: 40 @ 20.
	self assert: box position equals: 15 @ 25
]
