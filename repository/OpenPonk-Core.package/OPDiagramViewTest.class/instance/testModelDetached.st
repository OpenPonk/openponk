tests
testModelDetached
	view := OPDiagramView new.
	self should: [ view model ] raise: AssertionFailure