Class {
	#name : #SpLinkTableColumn,
	#superclass : #SpTableColumn,
	#instVars : [
		'action',
		'url'
	],
	#category : #'OpenPonk-Pharo8SysExtensions'
}

{ #category : #'as yet unclassified' }
SpLinkTableColumn class >> title: aString evaluated: aBlock action: actionBlock [

	^ self new 
		title: aString;
		evaluated: aBlock;
		action: actionBlock;
		yourself
]

{ #category : #'as yet unclassified' }
SpLinkTableColumn class >> title: aString evaluated: aBlock url: urlBlock [

	^ self new 
		title: aString;
		evaluated: aBlock;
		url: urlBlock;
		yourself
]

{ #category : #accessing }
SpLinkTableColumn >> acceptColumnVisitor: aBuilder [

	^ aBuilder visitLinkColumn: self
]

{ #category : #accessing }
SpLinkTableColumn >> action [
	^ action
]

{ #category : #accessing }
SpLinkTableColumn >> action: anObject [
	action := anObject
]

{ #category : #accessing }
SpLinkTableColumn >> url [
	^ url
]

{ #category : #accessing }
SpLinkTableColumn >> url: anObject [
	url := anObject
]
