"
I represent a label position in the layout.
Additionally I have an index to keep easier track of things (mainly debugging).
"
Class {
	#name : #DCRTLPositionNode,
	#superclass : #DCRTLNode,
	#instVars : [
		'index'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #accessing }
DCRTLPositionNode >> index [
	^ index
]

{ #category : #accessing }
DCRTLPositionNode >> index: aNumber [
	index := aNumber
]

{ #category : #testing }
DCRTLPositionNode >> isPosition [
	^ true
]

{ #category : #'as yet unclassified' }
DCRTLPositionNode >> label [
	^ 'P(' , self index asString , ')'
]
