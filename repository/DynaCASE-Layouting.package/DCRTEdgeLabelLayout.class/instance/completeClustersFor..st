as yet unclassified
completeClustersFor: clusterGraphs
	^ clusterGraphs flatCollect: [ :each | self completeClusterFor: each ]