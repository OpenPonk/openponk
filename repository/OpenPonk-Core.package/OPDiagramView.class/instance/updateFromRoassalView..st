accessing
updateFromRoassalView: aView
	self
		camera:
			(OPDiagramViewCamera new
				offset: aView canvas camera position;
				zoom: aView canvas camera scale)