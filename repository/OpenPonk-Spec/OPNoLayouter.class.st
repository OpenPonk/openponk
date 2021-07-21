Class {
	#name : #OPNoLayouter,
	#superclass : #OPLayouter,
	#category : #'OpenPonk-Spec-Layouting'
}

{ #category : #accessing }
OPNoLayouter >> allEdges [
	^ #()
]

{ #category : #accessing }
OPNoLayouter >> allNodes [
	^ #()
]

{ #category : #layouts }
OPNoLayouter >> defaultLayout [
	"do nothing"
]
