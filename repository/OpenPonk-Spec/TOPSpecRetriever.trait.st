"
I provide a way to access Spec Layouts by their pragma names.
"
Trait {
	#name : #TOPSpecRetriever,
	#category : 'OpenPonk-Spec-Windows'
}

{ #category : #api }
TOPSpecRetriever >> retrieveSpec: aSelector [
	((SpecPragmaCollector behavior: self class class)
		filter: [ :pragma | pragma keyword = #spec: and: [ pragma arguments first = aSelector ] ];
		reset;
		collected) ifNotEmpty: [ :pragmas | ^ super retrieveSpec: pragmas first method selector ].
	^ super retrieveSpec: aSelector
]
