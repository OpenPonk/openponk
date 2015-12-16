as yet unclassified
routesFor: edges visibility: visGraph
	| routes |
	routes := edges collect: [ :each | each -> (self routeFor: each visibility: visGraph) ].
	routes do: [ :pair | self applyRoute: pair value to: pair key ]