tests
testModelId
	self
		assert: (reader modelIdFrom: '8dc6a587-14f8-494e-82aa-d04b155a1ecd')
		equals: (UUID fromString: '8dc6a587-14f8-494e-82aa-d04b155a1ecd').
	self assert: (reader modelIdFrom: '150') equals: 150