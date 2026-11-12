Class {
	#name : 'OPTestEdgeLabel',
	#superclass : 'OPEdgeLabel',
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPTestEdgeLabel >> defaultAnchorConstraintPosition [
	^ OPRSAnchorConstraintBalanceReference balance: 0.5
]

{ #category : 'accessing' }
OPTestEdgeLabel >> defaultMinDistance [
	^ 10
]

{ #category : 'accessing' }
OPTestEdgeLabel >> defaultText [
	^ 'edge-label'
]
