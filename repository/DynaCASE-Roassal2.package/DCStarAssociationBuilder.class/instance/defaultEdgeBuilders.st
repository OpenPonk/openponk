setting
defaultEdgeBuilders
	self
		sourcesEdgeBuilder: [ :from :to | 
					RTStyledMultiLine new
						attachPoint: RTShorterDistanceWithOffsetAttachPoint instance;
						color: Color black;
						edgeFrom: from to: to ];
		targetsEdgeBuilder: [ :from :to | 
					RTStyledMultiLine new
						attachPoint: RTShorterDistanceWithOffsetAttachPoint instance;
						color: Color black;
						emptyArrowHead;
						edgeFrom: from to: to ]