import ballerina/http;
import ballerina/log;
import ballerina/mcp;

listener mcp:StreamableHttpListener mcpListener = new (8080);

@mcp:StreamableHttpServiceConfig {info: {name: "MCP Service", version: "1.0.0"}}
service mcp:StreamableHttpService /mcp on mcpListener {
    # Adds two numbers together
    remote function add(int a, int b, @http:Header {name: "Authorization"} string authorization) returns int {
        log:printInfo(string `${authorization}`);
        return a + b;
    }

}
