announcements
subscribeTo: aDiagramController
	aDiagramController model
		when: OPOpenEditorAnnouncement
		do: [ :ann | workbench openEditorOn: ann model ]