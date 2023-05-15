Class {
	#name : #OPDiagramElementTestCase,
	#superclass : #TestCase,
	#instVars : [
		'element'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #testing }
OPDiagramElementTestCase class >> isAbstract [
	^ self = OPDiagramElementTestCase
]

{ #category : #accessing }
OPDiagramElementTestCase >> elementClass [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
OPDiagramElementTestCase >> elementInstance [
	^ self elementClass new
]

{ #category : #running }
OPDiagramElementTestCase >> setUp [
	super setUp.
	element := self elementInstance
]
