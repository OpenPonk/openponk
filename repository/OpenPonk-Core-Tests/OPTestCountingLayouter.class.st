"
Test double layouter that records layout invocation counts without modifying element coordinates.
"
Class {
	#name : 'OPTestCountingLayouter',
	#superclass : 'OPLayouter',
	#instVars : [
		'dominanceTreeLayoutCount'
	],
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'userinterface' }
OPTestCountingLayouter >> applyLayout: aTwoArgBlock [
	^ self
]

{ #category : 'layouts' }
OPTestCountingLayouter >> defaultLayout [
	^ self
]

{ #category : 'layouts' }
OPTestCountingLayouter >> dominanceTreeLayout [
	dominanceTreeLayoutCount := self dominanceTreeLayoutCount + 1
]

{ #category : 'accessing' }
OPTestCountingLayouter >> dominanceTreeLayoutCount [
	^ dominanceTreeLayoutCount ifNil: [ 0 ]
]
