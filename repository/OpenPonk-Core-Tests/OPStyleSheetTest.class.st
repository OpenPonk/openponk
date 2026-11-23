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
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
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
OPStyleSheetTest >> testCleanTypeNameWithGuillemetsAndPropertyNamedIfAbsent [

	styleSheet atType: ' «Kind» ' set: #fillColor to: Color orange.
	self assert: (styleSheet propertyNamed: #fillColor forElement: element ifAbsent: [ #missing ]) equals: #missing.
	styleSheet atType: '«OPDiagramElement»' set: #strokeColor to: Color purple.
	self assert: (styleSheet propertyNamed: #strokeColor forElement: element ifAbsent: [ #missing ]) equals: Color purple
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
OPStyleSheetTest >> testNotationStyleRegistryRemoveAndReset [

	| registry plugin |
	registry := OPNotationStyleRegistry new.
	plugin := OPTestPlugin new.

	registry removeAtPlugin: plugin type: 'Node' property: #fillColor.
	registry resetForPlugin: plugin.

	registry
		atPlugin: plugin
		type: 'Node'
		set: #fillColor
		to: Color red.
	registry removeAtPlugin: plugin type: 'Node' property: #nonExistentProperty.
	self
		assert: ((registry rulesForPlugin: plugin) includesKey: 'Node')
		description: 'Removing an absent property must keep existing type rules'.

	registry removeAtPlugin: plugin type: 'Node' property: #fillColor.
	self assertEmpty: (registry rulesForPlugin: plugin).

	registry
		atPlugin: plugin
		type: 'Node'
		set: #strokeColor
		to: Color blue.
	registry resetForPlugin: plugin.
	self assertEmpty: (registry rulesForPlugin: plugin)
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
