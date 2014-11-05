tests
testCreateController
	| ctrl |
	ctrl := self createController.
	self assert: ctrl class = DCController