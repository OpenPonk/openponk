tests
testCreateModel
	self class = DCFsmVertexControllerTest
		ifTrue: [ ^ self ].
	self assert: ctrl createModel class = self modelClass