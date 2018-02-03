accessing
fullVersion
	^ String
		streamContents: [ :stream | 
			stream << self version.
			self gitCommit ifNotNil: [ stream << '+sha.' << self gitCommit ] ]