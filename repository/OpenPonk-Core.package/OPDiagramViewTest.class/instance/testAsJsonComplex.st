tests
testAsJsonComplex
	view := OPDiagramView new
		camera:
			(OPDiagramViewCamera new
				offset: 20 @ 30;
				zoom: 1.2);
		project: OPProject new;
		layout: {'Person' -> (27 @ 23)} asDictionary;
		options: {'key' -> 'value'} asDictionary.
	self
		assert: (STON fromString: view asJson)
		equals:
			(STON
				fromString:
					'{ 	"camera" : { "offset" : { "x" : 20, "y" : 30 }, "zoom" : 1.2 }	,
		"filters" : [  ],
		"layout" : { "Person" : { "x" : 27, "y" : 23 } },
		"options" : { "key" : "value" },
		"visibleElements" : [  ] }')