"
Helper class for workbench tests
"
Class {
	#name : 'OPWorkbenchMockProjectController',
	#superclass : 'Object',
	#instVars : [
		'saveBlock',
		'isSaved'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'initialization' }
OPWorkbenchMockProjectController >> initialize [
	super initialize.
	isSaved := false
]

{ #category : 'accessing' }
OPWorkbenchMockProjectController >> isSaved [
	^ isSaved
]

{ #category : 'accessing' }
OPWorkbenchMockProjectController >> saveBlock: aBlock [
	saveBlock := aBlock
]

{ #category : 'actions' }
OPWorkbenchMockProjectController >> saveProject [
	"Simulate project saving and trigger the test block if configured"
	isSaved := true.
	saveBlock ifNotNil: [ saveBlock value ]
]
