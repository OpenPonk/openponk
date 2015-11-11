as yet unclassified
defaultConfiguration
	^ Dictionary new
		at: #edgeMarks put: true;
		at: #highlightLabels put: true;
		at: #labelPositions put: true;
		at: #overlapGraph put: false;
		at: #clusterGraphs put: false;
		at: #completeClusters put: false;
		at: #matchingGraph put: false;
		at: #index put: true;
		at: #penalty put: false;
		yourself