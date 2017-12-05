initialization
setUp
	super setUp.
	extractor := SlReportExtractor new.
	registry := OPPluginRegistry new.
	registry add: OPTestPlugin new