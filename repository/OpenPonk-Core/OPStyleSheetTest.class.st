"
Verifies cascading resolution of styles from diagram style sheets and precedence of local overrides.
"
Class {
	#name : 'OPStyleSheetTest',
	#superclass : 'TestCase',
	#instVars : [
		'diagram',
		'styleSheet',
		'element'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPStyleSheetTest >> setUp [
	super setUp.
	diagram := OPDiagram new.
	styleSheet := OPStyleSheet new.
	diagram styleSheet: styleSheet.
	element := OPDiagramElement in: diagram
]

{ #category : 'running' }
OPStyleSheetTest >> tearDown [
	element := nil.
	styleSheet := nil.
	diagram := nil.
	super tearDown
]

{ #category : 'tests' }
OPStyleSheetTest >> testLocalStyleOverridesTypeStyle [
	styleSheet atType: 'OPDiagramElement' set: #fillColor to: Color green.
	element stylePropertyNamed: #fillColor put: Color blue.
	self
		assert: (element stylePropertyNamed: #fillColor ifAbsent: [ Color white ])
		equals: Color blue.
	element removeLocalStylePropertyNamed: #fillColor.
	self
		assert: (element stylePropertyNamed: #fillColor ifAbsent: [ Color white ])
		equals: Color green
]

{ #category : 'tests' }
OPStyleSheetTest >> testStyleSheetInheritedByNestedDiagramElement [
	| child |
	child := OPDiagramElement in: element.
	styleSheet atType: 'OPDiagramElement' set: #fillColor to: Color yellow.
	self
		assert: (child stylePropertyNamed: #fillColor ifAbsent: [ Color white ])
		equals: Color yellow
]

{ #category : 'tests' }
OPStyleSheetTest >> testTypeStyleResolvedWhenNoLocalStyle [
	styleSheet atType: 'OPDiagramElement' set: #fillColor to: Color green.
	self
		assert: (element stylePropertyNamed: #fillColor ifAbsent: [ Color white ])
		equals: Color green
]
