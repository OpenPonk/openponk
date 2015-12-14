accessing
edges: aCollection
	[ edges isNotEmpty ] whileTrue: [ self removeEdge: edges anyOne ].
	aCollection do: [ :each | self addEdge: each ]