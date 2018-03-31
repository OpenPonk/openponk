announcements
subscribeTo: aDiagramController
	aDiagramController model announcer
		when: OPOpenEditorAnnouncement
		do: [ :ann | workbench openEditorOn: ann model ].
	aDiagramController model announcer
		when: OPCloseEditorAnnouncement
		do: [ :ann | workbench closeEditorOf: ann model ]