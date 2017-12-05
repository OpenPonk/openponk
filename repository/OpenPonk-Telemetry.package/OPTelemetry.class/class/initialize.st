initialization
initialize
	SlReporter host: self errorReportUrl.
	SlReporter enabled: true.
	SlReporter autoSubmit: true.
	SlReporter showSummary: false.
	SlReporter showNotification: true