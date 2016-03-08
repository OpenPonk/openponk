saving
serializedDiagrams
	^ (controllers
		select: [ :each | each className = #DCFsmController ]
		thenCollect: [ :each | 
			each model dcID asString
				-> (#DCFsmGraphML asClass new export: each model withLayout: each layout) ])
		asDictionary