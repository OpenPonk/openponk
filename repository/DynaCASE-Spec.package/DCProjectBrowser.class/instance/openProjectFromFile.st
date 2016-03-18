as yet unclassified
openProjectFromFile
	| project stream data |
	stream := UIManager default
		fileOpen: 'Open project from .json file'
		extensions: #('json').
	stream ifNil: [ ^ self ].
	data := STON fromStream: stream.
	project := DCProject named: ((data at: #project) at: #name).
	project fileName: stream name asFileReference.
	(data at: #diagrams)
		valuesDo: [ :each | 
			| dict |
			dict := #DCFsmGraphML asClass new import: each.
			project addModel: (dict at: #model).
			project layout: (dict at: #layout) for: (dict at: #model) ].
	self openProject: project