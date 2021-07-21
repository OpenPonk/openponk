Class {
	#name : #OPRTHighlighter,
	#superclass : #RTBuilder,
	#instVars : [
		'model'
	],
	#category : 'OpenPonk-Roassal2-Builders'
}

{ #category : #'as yet unclassified' }
OPRTHighlighter class >> highlight: anElement color: aColor [
	^ (self allSubclasses detect: [ :each | each isFor: anElement ]) new
		highlight: anElement
		color: aColor
]

{ #category : #testing }
OPRTHighlighter class >> isFor: anElement [
	^ false
]

{ #category : #attributes }
OPRTHighlighter >> attributeKey [
	^ self class name
]

{ #category : #attributes }
OPRTHighlighter >> clearStore [
	model removeAttributeAt: self attributeKey ifAbsent: [  ]
]

{ #category : #attributes }
OPRTHighlighter >> hasStore [
	^ model isNotNil and: [ model hasAttribute: self attributeKey ]
]

{ #category : #protocol }
OPRTHighlighter >> highlight: anElement color: aColor [
	self subclassResponsibility
]

{ #category : #attributes }
OPRTHighlighter >> load [
	^ model attributeAt: self attributeKey
]

{ #category : #protocol }
OPRTHighlighter >> remove [
	^ self subclassResponsibility
]

{ #category : #attributes }
OPRTHighlighter >> store: anObject [
	model attributeAt: self attributeKey put: anObject
]
