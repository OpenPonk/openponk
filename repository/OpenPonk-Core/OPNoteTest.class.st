"
Unit tests for OPNote. 
Ensures that visual notes are correctly constructed, rendered, and initialized without an underlying structural domain model.
"
Class {
	#name : 'OPNoteTest',
	#superclass : 'OPAbstractNodeTest',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'instance creation' }
OPNoteTest >> newModelInstance [

	^ nil
]

{ #category : 'hooks' }
OPNoteTest >> shapeClass [
	^ OPNote
]

{ #category : 'tests' }
OPNoteTest >> testBoundaryAndControllerRenderingAndStyles [

	| boundary |
	self assert: OPBoundaryController diagramElementClass identicalTo: OPBoundary.
	self assert: OPBoundaryController modelClass identicalTo: OPBoundary.
	self assert: OPBoundaryController paletteItemName equals: #boundary.
	self assert: OPBoundaryController viewModelClass identicalTo: OPBoundaryViewModel.
	self assertCollection: OPBoundary stonAllInstVarNames includesAll: #( #name ).

	boundary := OPBoundary new.
	boundary name: 'System Boundary'.
	self assert: boundary text equals: 'System Boundary'.
	self
		assert: (boundary printString includesSubstring: '(''System Boundary'')')
		description: 'Boundary printString should contain boundary name'.

	boundary renderIn: canvas.
	boundary fillColor: Color orange.
	boundary strokeColor: Color brown.
	boundary updateRenderFromStyles.
	self assert: boundary roassalShape color equals: Color orange.
	self assert: boundary roassalShape borderColor equals: Color brown.
	boundary removeRender
]

{ #category : 'tests' }
OPNoteTest >> testDiagramOnlyShapeBehaviorAndJsonMapping [
	| shape1 shape2 json decoded |
	shape1 := OPDiagramOnlyShape new.
	shape2 := OPDiagramOnlyShape new.
	self assert: shape1 isDiagramOnly description: 'OPDiagramOnlyShape should answer true to isDiagramOnly'.
	self assert: shape1 uuid isNotNil description: 'OPDiagramOnlyShape should initialize a UUID'.
	self assert: shape1 modelElements equals: { shape1 }.
	shape1 modelElements: { shape1 }.
	self should: [ shape1 modelElements: { shape2 } ] raise: ShouldNotImplement.
	self assert: shape1 equals: shape1.
	self assert: shape1 hash equals: shape1 uuid hash.
	self deny: (shape1 = shape2) description: 'Two distinct diagram-only shapes should not be equal'.
	self assert: ((shape1 < shape2) or: [ shape2 < shape1 ]) description: 'Distinct UUIDs should have strict ordering'.
	self assertCollection: OPDiagramOnlyShape stonAllInstVarNames includesAll: #( #uuid ).
	json := NeoJSONWriter toString: shape1.
	decoded := NeoJSONReader fromString: json as: OPDiagramOnlyShape.
	self assert: decoded uuid equals: shape1 uuid
]

{ #category : 'running' }
OPNoteTest >> testEmpty [

	self skip
]

{ #category : 'tests' }
OPNoteTest >> testNoteAndControllerRenderingStylesAndPrinting [

	| note nonTriangleShapes triangleShape |
	self assert: OPNoteController diagramElementClass identicalTo: OPNote.
	self assert: OPNoteController modelClass identicalTo: OPNote.
	self assert: OPNoteController paletteItemName equals: #note.
	self assert: OPNoteController viewModelClass identicalTo: OPNoteViewModel.
	self assertCollection: OPNote stonAllInstVarNames includesAll: #( #text ).

	note := OPNote new.
	note text: 'Short note'.
	self
		assert: (note printString includesSubstring: '(''Short note'')')
		description: 'Short note printString should contain full text'.
	note text: 'This is a very long note text exceeding twenty characters'.
	self
		assert: (note printString includesSubstring: '''...)')
		description: 'Long note printString should be truncated with ellipsis'.

	note renderIn: canvas.
	self assert: note isRendered description: 'Note should be rendered in canvas'.
	note fillColor: Color green.
	note strokeColor: Color red.
	note updateRenderFromStyles.
	nonTriangleShapes := note attachedElementShapes allButLast.
	triangleShape := note attachedElementShapes last.
	self
		assert: (nonTriangleShapes allSatisfy: [ :each | each color = Color green ])
		description: 'Note body boxes should have exact fillColor'.
	self assert: triangleShape color equals: Color green slightlyDarker.
	self
		assert: (note lines allSatisfy: [ :each | each color = Color red ])
		description: 'Note border lines should have exact strokeColor'.
	note removeRender.
	self assertEmpty: note lines
]
