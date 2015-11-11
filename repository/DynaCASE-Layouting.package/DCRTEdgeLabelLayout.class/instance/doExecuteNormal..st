hook
doExecuteNormal: elementsCollection
	| edgeMarks positions overlapGraph clusterGraphs completeClusters matchingGraph assignment |
	elements := elementsCollection.
	edgeMarks := self allEdgeMarks.
	positions := self initialPositions.
	positions := self removeFeatureOverlaps: positions.
	positions := self indexPositions: positions.
	overlapGraph := self overlapGraphFor: positions.
	clusterGraphs := self clusterGraphsFor: overlapGraph.
	completeClusters := self completeClustersFor: clusterGraphs.
	matchingGraph := self matchingGraphFor: overlapGraph classes: completeClusters.
	assignment := self findAssignmentFor: matchingGraph.
	self applyAssignment: assignment.
	assignedLabels addAll: self batchOfUnassignedLabels.
	unassignedLabels removeAll: self batchOfUnassignedLabels.
	unassignedLabels ifNotEmpty: [ self doExecute: elementsCollection ]