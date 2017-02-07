saving
serializedDiagrams
	^ (controllers
		select: [ :each | each className = #OPFsmController ]
		thenCollect: [ :each | 
			each model uuid asString
				-> (#OPFsmGraphML asClass new export: each model withLayout: each layout) ])
		asDictionary