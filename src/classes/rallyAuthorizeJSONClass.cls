public with sharing class rallyAuthorizeJSONClass {
	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class OperationResult {
		public String rallyAPIMajor {get;set;}
		public String rallyAPIMinor {get;set;}
		public List<Errors> Errors {get;set;}
		public List<Errors> Warnings {get;set;}
		public String SecurityToken {get;set;}

		public OperationResult(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == '_rallyAPIMajor') {
							rallyAPIMajor = parser.getText();
						} else if (text == '_rallyAPIMinor') {
							rallyAPIMinor = parser.getText();
						} else if (text == 'Errors') {
							Errors = new List<Errors>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								Errors.add(new Errors(parser));
							}
						} else if (text == 'Warnings') {
							Warnings = new List<Errors>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								Warnings.add(new Errors(parser));
							}
						} else if (text == 'SecurityToken') {
							SecurityToken = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OperationResult consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public OperationResult OperationResult {get;set;}

	public rallyAuthorizeJSONClass(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'OperationResult') {
						OperationResult = new OperationResult(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Errors {

		public Errors(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Errors consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static rallyAuthorizeJSONClass parse(String json) {
		return new rallyAuthorizeJSONClass(System.JSON.createParser(json));
	}
	/*
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{\"OperationResult\": {\"_rallyAPIMajor\": \"2\", \"_rallyAPIMinor\": \"0\", \"Errors\": [], \"Warnings\": [], \"SecurityToken\": \"2b8a84c3-4750-42b7-afd1-d6b38ee31106\"}}';
		rallyAuthorizeJSONClass r = parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		OperationResult objOperationResult = new OperationResult(System.JSON.createParser(json));
		System.assert(objOperationResult != null);
		System.assert(objOperationResult.rallyAPIMajor == null);
		System.assert(objOperationResult.rallyAPIMinor == null);
		System.assert(objOperationResult.Errors == null);
		System.assert(objOperationResult.Warnings == null);
		System.assert(objOperationResult.SecurityToken == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		rallyAuthorizeJSONClass objRoot = new rallyAuthorizeJSONClass(System.JSON.createParser(json));
		System.assert(objRoot != null);
		System.assert(objRoot.OperationResult == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Errors objErrors = new Errors(System.JSON.createParser(json));
		System.assert(objErrors != null);
	}
	*/
}