as yet unclassified
saveProject: aProject to: aFolder
	"I use temp files because autoformatting is broken."

	| projectFile modelsFile |
	aFolder ensureCreateDirectory.
	(aFolder / 'models') ensureCreateDirectory.
	projectFile := aFolder / 'project.xml'.
	projectFile
		ensureDelete;
		writeStreamDo: [ :stream | self writeProject: aProject on: stream ].
	modelsFile := aFolder / 'models.xml'.
	modelsFile
		ensureDelete;
		writeStreamDo: [ :stream | self writeModelReferences: aProject models on: stream ]