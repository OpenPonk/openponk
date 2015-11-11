as yet unclassified
batchOfUnassignedLabels
	^ self edges collect: [ :e | self labelForEdge: e ]