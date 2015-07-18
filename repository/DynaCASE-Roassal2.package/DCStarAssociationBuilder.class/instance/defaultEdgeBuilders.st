setting
defaultEdgeBuilders
	self
		sourcesEdgeBuilder: [ :from :to | 
					DCRTStyledMultiLine new
						attachPoint: RTShorterDistanceWithOffsetAttachPoint instance;
						color: Color black;
						edgeFrom: from to: to ];
		targetsEdgeBuilder: [ :from :to | 
					DCRTStyledMultiLine new
						attachPoint: RTShorterDistanceWithOffsetAttachPoint instance;
						color: Color black;
						emptyArrowHead;
						edgeFrom: from to: to ]