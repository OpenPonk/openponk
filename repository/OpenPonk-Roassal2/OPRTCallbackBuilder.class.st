"
I am used to postpone adding objects to RTView.

For example RTLabelled requires having view specified on creation time; this wraps such situations in a callback.

I can be added to the view with ==myCallback renderIn: view==
"
Class {
	#name : #OPRTCallbackBuilder,
	#superclass : #RTBuilder,
	#instVars : [
		'block'
	],
	#category : #'OpenPonk-Roassal2-Builders'
}

{ #category : #'instance creation' }
OPRTCallbackBuilder class >> block: aBlock [
	^ self new
		block: aBlock;
		yourself
]

{ #category : #testing }
OPRTCallbackBuilder class >> isDeprecated [
	^ true
]

{ #category : #accessing }
OPRTCallbackBuilder >> block: aBlock [
	block := aBlock
]

{ #category : #hooks }
OPRTCallbackBuilder >> renderIn: aView [
	| element |
	element := block cull: aView.
	element view ifNil: [ element renderIn: aView ].
	^ element
]
