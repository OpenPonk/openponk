opening
shouldUseEditorFormFor: aLayoutStyle
	((SpecPragmaCollector behavior: self class class)
		filter: [ :pragma | pragma keyword = #spec: and: [ pragma arguments first = aLayoutStyle ] ];
		reset;
		collected)
		ifNotEmpty: [ :pragmas | 
			pragmas first method pragmas
				detect: [ :pragma | pragma keyword = #useEditorForm ]
				ifFound: [ ^ true ] ].
	^ false