as yet unclassified
testConvertClassAttributes
	| class first second |
	class := self convertClass elements first.
	self assert class attributes size = 2.	"
"
	first := class attributes first.
	self assert: first name = 'firstInstance'.
	self assert: first type = nil.
	self assert: first defaultValue = nil.
	self assert: first multiplicity = DCUmlMultiplicity one.
	self assert: first features isAbstract = false.
	self assert: first features isClassSide = false.
	self assert: first features stereotype = nil.
	self assert: first features visibility = DCUmlFeature private.	"
"
	second := class attributes second.
	self assert: second name = 'secondInstance'.
	self assert: second type = 'N/A'.
	self assert: second defaultValue = 'N/A'.
	self assert: second multiplicity = DCUmlMultiplicity one.
	self assert: second features isAbstract = false.
	self assert: second features isClassSide = false.
	self assert: second features stereotype = nil.
	self assert: second features visibility = DCUmlFeature private