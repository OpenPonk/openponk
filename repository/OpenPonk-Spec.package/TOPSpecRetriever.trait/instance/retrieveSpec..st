api
retrieveSpec: aSelector
	((SpecPragmaCollector behavior: self class class)
		filter: [ :pragma | pragma keyword = #spec: and: [ pragma arguments first = aSelector ] ];
		reset;
		collected) ifNotEmpty: [ :pragmas | ^ super retrieveSpec: pragmas first method selector ].
	^ super retrieveSpec: aSelector