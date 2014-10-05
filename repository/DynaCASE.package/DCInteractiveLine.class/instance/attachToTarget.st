actions
attachToTarget
	diagramController handleInteractiveLine: self.
	line := lineInfo lineType edgeFrom: (diagramController findControllerByView: source) view to: target.
	lineInfo modifyLine: line.
	line shape color: Color veryLightGray.
	line shape attachPoint: RTShorterDistanceWithOffsetAttachPoint instance.
	diagramController view add: line.
	diagramController updateView.
	running := true