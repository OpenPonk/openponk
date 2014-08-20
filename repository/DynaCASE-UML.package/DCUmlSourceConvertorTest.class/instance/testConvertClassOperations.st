as yet unclassified
testConvertClassOperations
	| class first second |
	class := self convertClass elements first.
	self assert class operations size = 3.
	nil.
	first := class operations first.
	self assert: first name = 'firstInstance'.
	self assert: first parameters size = 0.
	self assert: first returnValue = 'N/A'.
	self assert: first features isAbstract = false.
	self assert: first features isClassSide = false.
	self assert: first features stereotype = nil.
	self assert: first features visibility = DCUmlFeature public.
	nil.
	second := class operations second.
	self assert: second name = 'secondInstance'.
	self assert: second parameters size = 1.
	self assert: second parameters first name = 'anObject'.
	self assert: second parameters first defaultValue = nil.
	self assert: second returnValue = nil.
	self assert: second features isAbstract = false.
	self assert: second features isClassSide = false.
	self assert: second features stereotype = nil.
	self assert: second features visibility = DCUmlFeature public