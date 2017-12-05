tests
testExporterVersion
	self assert: persistence exporter equals: 'OpenPonk'.
	self assert: persistence exporterVersion equals: OPVersion version