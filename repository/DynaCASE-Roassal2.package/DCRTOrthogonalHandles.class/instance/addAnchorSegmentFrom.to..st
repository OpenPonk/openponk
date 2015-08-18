private
addAnchorSegmentFrom: fromPoint to: toPoint
	handles addFirst: (DCRTAnchorHandle position: fromPoint).
	handles addLast: (DCRTAnchorHandle position: toPoint)