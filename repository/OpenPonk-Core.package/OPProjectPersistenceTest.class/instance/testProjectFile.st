tests
testProjectFile
	| result |
	result := String
		streamContents: [ :stream | 
			persistence
				writeProject:
					(OPProject new
						name: 'My Project';
						uuid: (UUID fromString: '7f5ee44a-1655-4061-a78e-db9578a2226c'))
				on: stream ].
	self
		assert: (result copyWithRegex: '<timestamp>.*<\/timestamp>' matchesReplacedWith: 'TIMESTAMP')
		equals:
			'<?xml version="1.0"?>
<project>
    <name>My Project</name>
    <uuid>7f5ee44a-1655-4061-a78e-db9578a2226c</uuid>
    <documentation>
        <exporter>DynaCASE</exporter>
        <exporterVersion>0.0.0</exporterVersion>
        TIMESTAMP
    </documentation>
</project>'