settings
availableLayoutStyles
	^ ((SpecPragmaCollector behavior: self class)
		filter: [ :pragma | pragma keyword = #spec: ];
		reset;
		collected) collect: [ :pragma | pragma arguments first ]