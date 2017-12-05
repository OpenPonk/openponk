tests
testExporterVersion
	self assert: reader exporter equals: 'OpenPonk'.
	self assert: reader exporterVersion equals: OPVersion version