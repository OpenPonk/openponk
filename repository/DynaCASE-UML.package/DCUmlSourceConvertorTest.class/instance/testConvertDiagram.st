as yet unclassified
testConvertDiagram
	| diagram |
	diagram := self convertClass.
	self assert: (diagram isMemberOf: DCUmlClassDiagram).
	self assert: diagram elements size = 1