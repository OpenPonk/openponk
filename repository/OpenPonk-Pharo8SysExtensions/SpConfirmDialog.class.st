Class {
	#name : #SpConfirmDialog,
	#superclass : #Object,
	#instVars : [
		'title',
		'label',
		'acceptLabel',
		'cancelLabel',
		'onAccept'
	],
	#category : #'OpenPonk-Pharo8SysExtensions'
}

{ #category : #accessing }
SpConfirmDialog >> acceptLabel [
	^ acceptLabel
]

{ #category : #'as yet unclassified' }
SpConfirmDialog >> acceptLabel: aString [
	acceptLabel := aString
]

{ #category : #accessing }
SpConfirmDialog >> cancelLabel [
	^ cancelLabel
]

{ #category : #accessing }
SpConfirmDialog >> cancelLabel: aString [
	cancelLabel := aString
]

{ #category : #initialization }
SpConfirmDialog >> initialize [
	title := 'Confirm'.
	label := ''.
	acceptLabel := 'Yes'.
	cancelLabel := 'No'.
	onAccept := [ self inform: 'Accepted' ]
]

{ #category : #accessing }
SpConfirmDialog >> label [
	^ label
]

{ #category : #accessing }
SpConfirmDialog >> label: aString [
	label := aString
]

{ #category : #accessing }
SpConfirmDialog >> onAccept [
	^ onAccept
]

{ #category : #accessing }
SpConfirmDialog >> onAccept: aBlock [
	onAccept := aBlock
]

{ #category : #accessing }
SpConfirmDialog >> openDialogWithSpec [
	| result |
	result := UIManager default
		confirm: self label
		label: self title
		trueChoice: self acceptLabel
		falseChoice: self cancelLabel
		cancelChoice: nil
		default: false.
	result ifNil: [ ^ self ].
	result
		ifTrue: [ ^ self onAccept value ]
]

{ #category : #accessing }
SpConfirmDialog >> title [
	^ title
]

{ #category : #accessing }
SpConfirmDialog >> title: aString [
	title := aString
]
