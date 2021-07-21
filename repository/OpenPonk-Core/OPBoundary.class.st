Class {
	#name : #OPBoundary,
	#superclass : #OPCommonElement,
	#instVars : [
		'name'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'instance creation' }
OPBoundary class >> named: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #initialization }
OPBoundary >> initialize [
	super initialize.
	name := ''
]

{ #category : #accessing }
OPBoundary >> name [
	^ name
]

{ #category : #accessing }
OPBoundary >> name: aString [
	name := aString
]

{ #category : #printing }
OPBoundary >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPutAll: '(''';
		nextPutAll: self name;
		nextPutAll: ''')'
]
