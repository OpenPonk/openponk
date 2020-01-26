Class {
	#name : #OPShowHideElementsBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'browser',
		'component',
		'diagramController'
	],
	#category : #'OpenPonk-Spec-Tests'
}

{ #category : #running }
OPShowHideElementsBrowserTest >> setUp [
	component := NSMComponent new.
	diagramController := NSPERDiagramController new.
	diagramController view: RTView new.
	diagramController model: component.
	diagramController diagram: OPDiagram new.
	browser := OPShowHideElementsBrowser new.
	browser startOn: diagramController
]

{ #category : #tests }
OPShowHideElementsBrowserTest >> testDataElementTypesSelectionAll [
	| selection |
	selection := browser dataElementTypesSelection.
	self assert: selection equals: NSMDataElement dataElementTypes
]

{ #category : #tests }
OPShowHideElementsBrowserTest >> testDataElementTypesSelectionNone [
	| selection |
	NSMDataElement dataElementTypes
		do: [ :each | 
			component dataElements
				add: (NSMDataElement new type: (NSMDataElementType perform: each uncapitalized asSymbol)) ].
	selection := browser dataElementTypesSelection.
	self assert: selection equals: #()
]

{ #category : #tests }
OPShowHideElementsBrowserTest >> testDataElementTypesSelectionPrimaryOnly [
	| selection |
	NSMDataElement dataElementTypes
		do: [ :each | 
			component dataElements
				add: (NSMDataElement new type: (NSMDataElementType perform: each uncapitalized asSymbol)) ].
	diagramController showModelInDiagram: (component dataElements detect: #isPrimary).
	selection := browser dataElementTypesSelection.
	self assert: selection equals: #(Primary)
]
