instance creation
fromJson: aString
	^ (NeoJSONReader on: aString readStream)
		mapInstVarsFor: self;
		for: self
			do: [ :mapping | 
			(mapping mapInstVar: #camera) valueSchema: OPDiagramViewCamera.
			(mapping mapInstVar: #layout) valueSchema: #MapOfPoints.
			(mapping mapInstVar: #filters) valueSchema: #ListOfFilters ];
		mapInstVarsFor: OPDiagramViewCamera;
		for: OPDiagramViewCamera
			do: [ :mapping | (mapping mapInstVar: #offset) valueSchema: Point ];
		mapInstVarsFor: Point;
		for: #MapOfPoints customDo: [ :mapping | mapping mapWithValueSchema: Point ];
		for: #ListOfFilters
			customDo: [ :mapping | mapping listOfType: OrderedCollection andElementSchema: #Filter ];
		for: #Filter
			customDo: [ :mapping | mapping decoder: [ :data | NSPDiagramViewFilter decodeFrom: data ] ];
		nextAs: self