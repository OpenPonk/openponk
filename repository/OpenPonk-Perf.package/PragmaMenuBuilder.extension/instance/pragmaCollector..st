*OpenPonk-Perf
pragmaCollector: aCollector
	self assert: [ pragmaCollector isNil ] description: 'Pragma Collector cannot be changed.'.
	pragmaCollector := aCollector.
"	pragmaCollector whenChangedSend: #reset to: self"