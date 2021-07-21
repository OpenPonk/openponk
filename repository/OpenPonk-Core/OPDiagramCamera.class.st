"
I represent camera positioning over the view.
"
Class {
	#name : #OPDiagramCamera,
	#superclass : #Object,
	#instVars : [
		'offset',
		'zoom'
	],
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #accessing }
OPDiagramCamera class >> neoJsonMapping: mapper [
	mapper
		for: self
			do: [ :mapping | 
			mapping mapInstVars.
			(mapping mapInstVar: #offset) valueSchema: Point ];
		mapInstVarsFor: Point
]

{ #category : #accessing }
OPDiagramCamera >> offset [
	^ offset
]

{ #category : #accessing }
OPDiagramCamera >> offset: anObject [
	offset := anObject
]

{ #category : #accessing }
OPDiagramCamera >> zoom [
	^ zoom
]

{ #category : #accessing }
OPDiagramCamera >> zoom: anObject [
	zoom := anObject
]
