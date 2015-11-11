hook
doExecuteVisualized: elementsCollection
	| edgeMarks positions overlapGraph clusterGraphs completeClusters matchingGraph assignment conf |
	conf := visualizer class Configuration.
	elements := elementsCollection.
	visualizer view: self edges anyOne view.
	(conf at: #highlightLabels)
		ifTrue: [ visualizer highlightLabels ].
	edgeMarks := self allEdgeMarks.
	(conf at: #edgeMarks)
		ifTrue: [ visualizer showEdgeMarks: edgeMarks ].
	positions := self initialPositions.
	positions := self removeFeatureOverlaps: positions.
	positions := self indexPositions: positions.
	(conf at: #labelPositions)
		ifTrue:
			[ visualizer
				showLabelPositions: positions
				labeled:
					((conf at: #index)
						ifTrue: [ [ :posNode :label | posNode index ] ]
						ifFalse:
							[ [ :posNode :label | 
							(self penaltyForRanking: posNode model of: (self edgeForLabel: label)) asString , '|'
								,
									(self penaltyForEdgeProximity: posNode model of: (self edgeForLabel: label)) rounded
										asString , '/'
								,
									(self penaltyForElementProximity: posNode model of: (self edgeForLabel: label)) rounded
										asString ] ]) ].
	overlapGraph := self overlapGraphFor: positions.
	(conf at: #overlapGraph)
		ifTrue: [ visualizer showOverlapGraph: overlapGraph labeled: 'Overlap Graph' ].
	clusterGraphs := self clusterGraphsFor: overlapGraph.
	(conf at: #clusterGraphs)
		ifTrue: [ visualizer showClusters: clusterGraphs labeled: 'Clusters' ].
	completeClusters := self completeClustersFor: clusterGraphs.
	(conf at: #completeClusters)
		ifTrue: [ visualizer showClusters: completeClusters labeled: 'Complete Clusters' ].
	matchingGraph := self matchingGraphFor: overlapGraph classes: completeClusters.
	(conf at: #matchingGraph)
		ifTrue: [ visualizer showMatchingGraph: matchingGraph labeled: 'Matching Graph' ].
	assignment := self findAssignmentFor: matchingGraph.
	self applyAssignment: assignment.
	assignedLabels addAll: self batchOfUnassignedLabels.
	unassignedLabels removeAll: self batchOfUnassignedLabels.
	unassignedLabels ifNotEmpty: [ self doExecuteVisualized: elementsCollection ]