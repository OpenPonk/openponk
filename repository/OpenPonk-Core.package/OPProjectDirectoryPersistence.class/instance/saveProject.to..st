saving
saveProject: aProject to: aFolder
	aFolder ensureCreateDirectory.
	(aFolder / 'models') ensureCreateDirectory.
	(aFolder / '.history' / 'models') ensureCreateDirectory.
	(aFolder / 'project.xml')
		ensureDelete;
		writeStreamDo: [ :stream | self writeProject: aProject on: stream ].
	(aFolder / 'models.xml')
		ensureDelete;
		writeStreamDo: [ :stream | self writeModelReferences: aProject models on: stream ]