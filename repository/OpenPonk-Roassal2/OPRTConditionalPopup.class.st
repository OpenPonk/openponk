"
I am a popup that is activated only if the provided condition is met.
"
Class {
	#name : #OPRTConditionalPopup,
	#superclass : #RTPopup,
	#instVars : [
		'enabledCondition'
	],
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #accessing }
OPRTConditionalPopup >> enabledCondition: anObject [
	enabledCondition := anObject
]

{ #category : #initialization }
OPRTConditionalPopup >> initializeElement: element [
	element
		when: TRMouseClick
		do: [ :event | 
			self removeLastPopup.
			element trachelShape signalUpdate ].
		
	element
		when: TRMouseEnter
		do: [ :event | 
			self isEnabled ifTrue: [
				self createAndShowPopupFor: element event: event ] ].
	element
		when: TRMouseLeave
		do: [ :event | 
			self removeLastPopup.
			element trachelShape signalUpdate ].
	element
		when: TRMouseDragging
		do: [ :event | 
			self removeLastPopup.
			element trachelShape signalUpdate ]
]

{ #category : #testing }
OPRTConditionalPopup >> isEnabled [
	^ enabledCondition value
]
