as yet unclassified
convertClass
	| convertor diagram |
	convertor := DCUmlSourceConvertor new.
	diagram := convertor convert: DCUmlSCDummy.
	^ diagram