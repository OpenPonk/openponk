announcements
subscribeTo: aDiagramController
	aDiagramController model announcer
		when: OPOpenEditorAnnouncement
		do: [ :ann | workbench openEditorOn: ann model ]