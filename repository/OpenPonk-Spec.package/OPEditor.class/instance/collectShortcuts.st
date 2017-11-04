shortcuts
collectShortcuts
	^ ((PragmaCollector
		filter:
			[ :prg | prg keyword = #opEditorShortcut: and: [ prg arguments first = self plugin class name ] ])
		reset;
		collect: [ :prg | prg methodClass theNonMetaClass perform: prg methodSelector with: self ])
		flattened