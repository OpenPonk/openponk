"
I represent camera positioning over the view.
"
Class {
	#name : #OPDiagramViewCamera,
	#superclass : #Object,
	#instVars : [
		'offset',
		'zoom'
	],
	#category : #'OpenPonk-Core-Views'
}

{ #category : #accessing }
OPDiagramViewCamera >> offset [
	^ offset
]

{ #category : #accessing }
OPDiagramViewCamera >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
OPDiagramViewCamera >> zoom [
	^ zoom
]

{ #category : #accessing }
OPDiagramViewCamera >> zoom: anObject [
	zoom := anObject
]
