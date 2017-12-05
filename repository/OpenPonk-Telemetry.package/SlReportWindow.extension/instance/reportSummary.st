*OpenPonk-Telemetry-ShoreLine
reportSummary
	^ String
		streamContents: [ :stream | 
			| payload meta |
			meta := report copy.
			payload := meta removeKey: #payload.
			stream << (STON toJsonStringPretty: meta).
			stream cr.
			stream << (STON toJsonStringPretty: payload) ]