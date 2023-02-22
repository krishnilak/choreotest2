import ballerina/http;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/sql;

public type LikedItem record {|
    int user_id;
    int item_id;
|};

# A service representing a network-accessible API
# bound to port `9090`.
configurable string USER =?;
configurable string PASSWORD = ?;
configurable string HOST = ?;
configurable int PORT = ?;
configurable string DATABASE = ?;

final mysql:Client dbClient = check new(
    host=HOST, user=USER, password=PASSWORD, port=PORT, database=DATABASE);

isolated function likeItem(LikedItem li) returns int|error  {
    sql:ExecutionResult result = check dbClient->execute(`
        INSERT INTO liked (user_id, item_id)
        VALUES (${li.user_id}, ${li.item_id})
    `);
    int|string? lastInsertId = result.lastInsertId;
    if lastInsertId is int {
        return lastInsertId;
    } else {
        return error("Unable to obtain last insert ID");
    }
}

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

    resource function post .(@http:Payload LikedItem li) returns int|error? {
        return likeItem(li);
    }


 
   


}
