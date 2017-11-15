tests
testExporterVersion
	self assert: persistence exporter equals: 'OpenPonk'.
	self assert: persistence exporterVersion equals: '0.0.0'