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

{ #category : #accessing }
OPNote >> text [
	^ text
]

{ #category : #accessing }
OPNote >> text: aString [
	text := aString
]
