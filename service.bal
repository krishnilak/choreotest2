import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
configurable string USER = USER;
configurable string PASSWORD = PASSWORD;
configurable string HOST = HOST;
configurable int PORT = PORT;
configurable string DATABASE = DATABASE;

public type LikedItem record {|
    int user_id;
    int item_id;
|};

service / on new http:Listener(9090) {

    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, " + name;
    }

    isolated resource function post .(@http:Payload LikedItem li) {
       sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO liked (user_id, item_id)
        VALUES (${li.user_id}, ${li.item_id})
    `);
    }

    final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database=DATABASE);

}
