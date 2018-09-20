"
I am a node that represents cluster of nodes.
"
Class {
	#name : #DCRTLClusterNode,
	#superclass : #DCRTLNode,
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #testing }
DCRTLClusterNode >> isCluster [
	^ true
]

{ #category : #accessing }
DCRTLClusterNode >> label [
	^ 'C(' , self model asString , ')'
]
