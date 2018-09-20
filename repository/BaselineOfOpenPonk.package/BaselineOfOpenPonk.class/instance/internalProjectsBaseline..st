accessing
internalProjectsBaseline: spec
	spec
		baseline: 'OpenPonkModel'
		with: [ spec repository: 'github://openponk/openponk-model/repository' ].
	spec
		baseline: 'FileDialog'
		with: [ spec repository: 'github://peteruhnak/file-dialog/repository' ].
	spec
		baseline: 'Sentry'
		with: [ spec repository: 'github://peteruhnak/pharo-sentry/repository' ].
	spec
		baseline: 'SynchronizedLinks'
		with: [ spec repository: 'github://openponk/synchronized-links/repository' ]