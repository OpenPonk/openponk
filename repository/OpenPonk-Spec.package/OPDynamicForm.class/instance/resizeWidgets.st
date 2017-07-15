private - building widgets
resizeWidgets
	| font |
	font := LabelMorph labelFont class
		familyName: LabelMorph labelFont familyName
		pointSize: 9.
	self widgets values
		reject: [ :each | each isKindOf: OPSelectEntity ]
		thenDo: [ :each | each widget widget font: font ]