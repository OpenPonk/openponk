tests
testSettings
	self assert: SlReporter enabled.
	self assert: SlReporter autoSubmit.
	self deny: SlReporter showSummary.
	self assert: SlReporter showNotification