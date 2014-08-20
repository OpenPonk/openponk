as yet unclassified
testConvertClass
	| class |
	class := self convertClass elements first.
	self assert: (class isMemberOf: DCUmlClass).
	self assert: class name = 'DCUmlSCDummy'