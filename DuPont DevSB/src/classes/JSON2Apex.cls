/*******************************************************************************
Copyright © 2015 DuPont. All rights reserved. 
Author: Rajiv Kumar Bhatter
Email: Rajiv_Bhatter@infosys.com
Description: Class for converting JSON response to apex
 *****************************************************************************/

global class JSON2Apex {
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

    public class Registration {
        public String created {get;set;}
        public String expires {get;set;}
        public String updated {get;set;}
        public String registrar {get;set;}
        public List<String> statuses {get;set;}

        public Registration(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'created') {
                            created = parser.getText();
                        } else if (text == 'expires') {
                            expires = parser.getText();
                        } else if (text == 'updated') {
                            updated = parser.getText();
                        } else if (text == 'registrar') {
                            registrar = parser.getText();
                        } else if (text == 'statuses') {
                            statuses = new List<String>();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Registration consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public Response response {get;set;}

    public JSON2Apex(JSONParser parser) {
        while (parser.nextToken() != JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != JSONToken.VALUE_NULL) {
                    if (text == 'response') {
                        response = new Response(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Response {
        public String registrant {get;set;}
        public Registration registration {get;set;}
        public List<String> name_servers {get;set;}
        public Whois whois {get;set;}

        public Response(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'registrant') {
                            registrant = parser.getText();
                        } else if (text == 'registration') {
                            registration = new Registration(parser);
                        } else if (text == 'name_servers') {
                            name_servers = new List<String>();
                          
                        } else if (text == 'whois') {
                            whois = new Whois(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Response consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Whois {
        public String datee {get;set;}
        public String record {get;set;}

        public Whois(JSONParser parser) {
            while (parser.nextToken() != JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != JSONToken.VALUE_NULL) {
                        if (text == 'datee') {
                            datee = parser.getText();
                        } else if (text == 'record') {
                            record = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Whois consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
        public static JSON2Apex parse(String json) {
        return new JSON2Apex(System.JSON.createParser(json));
    }
    }