tests - rebuilding
testRebuildNonEmpty
	| subModel subController |
	subModel := OPTestEntityModel new.
	diagramController model entities add: subModel.
	diagramController rebuild.
	self assert: diagramController controllers size > 0.
	self
		shouldnt: [ subController := diagramController controllerForModel: subModel ]
		raise: NotFound.
	self assert: (diagramController view elements includes: subController figure)