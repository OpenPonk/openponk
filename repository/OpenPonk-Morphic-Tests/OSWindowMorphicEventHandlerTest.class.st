"
Verifies mouse-move event coalescing and deferred UI message handling in OSWindowMorphicEventHandler without touching the active Morphic world.
"
Class {
	#name : 'OSWindowMorphicEventHandlerTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Morphic-Tests-Morphic',
	#package : 'OpenPonk-Morphic-Tests',
	#tag : 'Morphic'
}

{ #category : 'tests' }
OSWindowMorphicEventHandlerTest >> testDispatchMorphicEventSkipsDeliveryWhenEventHandIsNil [

	| world hand handler eventWithoutHand handledEvents nextMessage |
	world := WorldMorph new.
	hand := HandMorph new.
	world addHand: hand.
	handledEvents := OrderedCollection new.
	(hand stub handleEvent: Any) will: [ :event | handledEvents add: event ].
	handler := OSWindowMorphicEventHandler new
		           morphicWorld: world;
		           yourself.
	eventWithoutHand := MouseMoveEvent new.
	handler dispatchMorphicEvent: eventWithoutHand.
	[ (nextMessage := world worldState deferredUIMessages nextOrNil) isNotNil ] whileTrue: [ nextMessage value ].
	self assertEmpty: handledEvents
]

{ #category : 'tests' }
OSWindowMorphicEventHandlerTest >> testDispatchMouseMoveEventCoalescesPreviousMouseMoveAndDeliversToActiveHand [

	| world hand handler firstMove secondMove buttonEvent unrelatedExecuted handledEvents nextMessage |
	world := WorldMorph new.
	hand := HandMorph new.
	world addHand: hand.
	world activeHand: hand.
	handledEvents := OrderedCollection new.
	(hand stub handleEvent: Any) will: [ :event | handledEvents add: event ].
	handler := OSWindowMorphicEventHandler new
		           morphicWorld: world;
		           yourself.
	unrelatedExecuted := false.
	world defer: [ unrelatedExecuted := true ].
	firstMove := MouseMoveEvent new
		             setType: #mouseMove
		             startPoint: 0 @ 0
		             endPoint: 10 @ 10
		             trail: #(  )
		             buttons: 0
		             hand: hand
		             stamp: 1.
	secondMove := MouseMoveEvent new
		              setType: #mouseMove
		              startPoint: 10 @ 10
		              endPoint: 20 @ 20
		              trail: #(  )
		              buttons: 0
		              hand: hand
		              stamp: 2.
	buttonEvent := MouseButtonEvent new
		               setType: #mouseDown
		               position: 20 @ 20
		               which: 4
		               buttons: 4
		               hand: hand
		               stamp: 3.
	handler dispatchMorphicEvent: firstMove.
	handler dispatchMorphicEvent: buttonEvent.
	handler dispatchMorphicEvent: secondMove.
	[ (nextMessage := world worldState deferredUIMessages nextOrNil) isNotNil ] whileTrue: [ nextMessage value ].
	self assert: unrelatedExecuted description: 'Unrelated deferred UI block must not be flushed by MouseMoveEvent'.
	self assertCollection: handledEvents asArray equals: {
			buttonEvent.
			secondMove }
]

{ #category : 'tests' }
OSWindowMorphicEventHandlerTest >> testDispatchMouseMoveEventPreservesNonBlockDeferredMessageSend [

	| world handler messageSend mouseMoveEvent queuedMessages nextMessage |
	world := WorldMorph new.
	handler := OSWindowMorphicEventHandler new
		           morphicWorld: world;
		           yourself.
	messageSend := MessageSend receiver: Object selector: #new.
	world defer: messageSend.
	mouseMoveEvent := MouseMoveEvent new.
	handler dispatchMorphicEvent: mouseMoveEvent.
	queuedMessages := OrderedCollection new.
	[ (nextMessage := world worldState deferredUIMessages nextOrNil) isNotNil ] whileTrue: [ queuedMessages add: nextMessage ].
	self assert: queuedMessages size equals: 2.
	self assert: queuedMessages first identicalTo: messageSend
]
