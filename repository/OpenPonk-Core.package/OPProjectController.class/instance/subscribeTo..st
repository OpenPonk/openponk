announcements
subscribeTo: aDiagramController
	aDiagramController model announcer
		when: OPOpenEditorRequest
		do: [ :ann | workbench openEditorOn: ann model ].
	aDiagramController model announcer
		when: OPCloseEditorAnnouncement
		do: [ :ann | workbench closeEditorOf: ann model ]