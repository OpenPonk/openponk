Class {
	#name : #OPNote,
	#superclass : #OPCommonElement,
	#instVars : [
		'text'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'public - shapes - texting' }
OPNote class >> withText: aString [
	^ self new
		text: aString;
		yourself
]

{ #category : #initialization }
OPNote >> initialize [
	super initialize.
	text := ''
]

{ #category : #printing }
OPNote >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '('''.

	self text size <= 20
		ifTrue: [ 
			aStream
				nextPutAll: self text;
				nextPut: $' ]
		ifFalse: [ 
			aStream
				nextPutAll: (self text takeFirst: 17);
				nextPutAll: '''...' ].
	aStream nextPutAll: ')'
]

{ #category : #accessing }
OPNote >> text [
	^ text
]

{ #category : #accessing }
OPNote >> text: aString [
	text := aString
]
