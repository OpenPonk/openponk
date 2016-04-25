tests
testProjectFile
	| result |
	result := String
		streamContents: [ :stream | persistence writeProject: (DCProject new name: 'My Project') on: stream ].
	self
		assert: (result copyWithRegex: '<timestamp>.*<\/timestamp>' matchesReplacedWith: 'TIMESTAMP')
		equals:
			'<?xml version="1.0"?>
<project>
    <name>My Project</name>
    <documentation>
        <exporter>DynaCASE</exporter>
        <exporterVersion>0.0-alpha</exporterVersion>
        TIMESTAMP
    </documentation>
</project>'