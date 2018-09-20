tests
testFromJsonComplex
	view := OPDiagramView
		fromJson:
			'{ 	"camera" : { "offset" : { "x" : 20, "y" : 30 }, "zoom" : 1.2 }	,
		"filters" : [ ],
		"layout" : { "Person" : { "x" : 27, "y" : 23 } },
		"options" : { "key" : "value" },
		"visibleElements" : [ "Person" ]	 }'.
	self assert: view camera offset equals: 20 @ 30.
	self assert: view camera zoom equals: 1.2.
	self assert: view filters species equals: OrderedCollection.
	self assert: view layout equals: {'Person' -> (27 @ 23)} asDictionary.
	self assert: view visibleElements equals: #('Person').
	self assert: view project isNil.
	self assert: view options equals: { 'key' -> 'value' } asDictionary.