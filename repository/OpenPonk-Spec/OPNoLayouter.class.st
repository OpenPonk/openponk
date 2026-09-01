"
Null Object implementation of OPLayouter that performs no automated layout operations, leaving element positions exactly as they are.
"
Class {
	#name : 'OPNoLayouter',
	#superclass : 'OPLayouter',
	#category : 'OpenPonk-Spec-Layouting',
	#package : 'OpenPonk-Spec',
	#tag : 'Layouting'
}

{ #category : 'userinterface' }
OPNoLayouter >> applyLayout: aTwoArgBlock [
	"do nothing"

	
]

{ #category : 'layouts' }
OPNoLayouter >> defaultLayout [
	"do nothing"
]
