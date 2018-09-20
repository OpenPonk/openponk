"
A DCTRConstraintTest is a test class for testing the behavior of DCTRConstraint
"
Class {
	#name : #OPRTElementsConstraintTest,
	#superclass : #TestCase,
	#instVars : [
		'conformingShape',
		'originShape'
	],
	#category : 'OpenPonk-Roassal2-Tests'
}

{ #category : #running }
OPRTElementsConstraintTest >> setUp [
	(originShape := TRBoxShape new) extent: 10 @ 10.
	(conformingShape := TRBoxShape new) extent: 20 @ 20
]

{ #category : #tests }
OPRTElementsConstraintTest >> testChangingExtent [
	
	OPRTElementsConstraint changeExtentOf: conformingShape like: originShape plus: 5 @ -5.
	self assert: conformingShape extent = (15 @ 5).
	self assert: originShape extent = (10 @ 10).
	
	originShape extent: 0 @ 0.
	self assert: conformingShape extent = (15 @ 5).
	
	OPRTElementsConstraint changeExtentOf: conformingShape like: originShape plus: 0 @ 0.
	self assert: conformingShape extent = (0 @ 0)
]

{ #category : #tests }
OPRTElementsConstraintTest >> testKeepingExtent [
	originShape extent: 10 @ 10.
	conformingShape extent: 20 @ 20.
	OPRTElementsConstraint keepExtentOf: conformingShape like: originShape plus: 5 @ -5.
	
	self assert: conformingShape extent = (15 @ 5).
	self assert: originShape extent = (10 @ 10).
	
	originShape extent: 0 @ 5.
	self assert: conformingShape extent = (5 @ 0)
]
