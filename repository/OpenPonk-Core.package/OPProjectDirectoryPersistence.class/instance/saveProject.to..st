saving
saveProject: aProject to: aFolder
	aFolder ensureCreateDirectory.
	(aFolder / 'models') ensureCreateDirectory.
	(aFolder / '.history' / 'models') ensureCreateDirectory.
	(aFolder / 'project.json')
		ensureDelete;
		writeStreamDo: [ :stream | stream << (self projectToJson: aProject) ].
	(aFolder / 'models.json')
		ensureDelete;
		writeStreamDo: [ :stream | stream << (self modelReferencesToJson: aProject models) ]