hook
doExecuteVisualized: elementsCollection
	| edgeMarks positions overlapGraph clusterGraphs completeClusters matchingGraph assignment |
	elements := elementsCollection.
	visualizer view: self edges anyOne view.
	visualizer highlightLabels.
	edgeMarks := self allEdgeMarks.
	visualizer showEdgeMarks: edgeMarks.
	positions := self initialPositions.
	positions := self removeFeatureOverlaps: positions.
	positions := self indexPositions: positions.
	visualizer showLabelPositions: positions.
	overlapGraph := self overlapGraphFor: positions.
	"visualizer showOverlapGraph: overlapGraph labeled: 'Overlap Graph'."
	clusterGraphs := self clusterGraphsFor: overlapGraph.
	"visualizer showClusters: clusterGraphs labeled: 'Clusters'."
	completeClusters := self completeClustersFor: clusterGraphs.
	"visualizer showClusters: completeClusters labeled: 'Complete Clusters'."
	matchingGraph := self matchingGraphFor: overlapGraph classes: completeClusters.
	visualizer showMatchingGraph: matchingGraph labeled: 'Matching Graph'.
	assignment := self findAssignmentFor: matchingGraph.
	self applyAssignment: assignment