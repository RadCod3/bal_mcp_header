import ballerina/ai;
import ballerina/mcp;

final ai:Agent aiAgent = check new (
    systemPrompt = {role: string `Does math`, instructions: string `Use available tools to do math`}, model = check ai:getDefaultModelProvider(), tools = [aiMcpbasetoolkit]
);

isolated class McpToolKit {
    *ai:McpBaseToolKit;
    private final mcp:StreamableHttpClient mcpClient;
    private final readonly & ai:ToolConfig[] tools;

    public isolated function init(string serverUrl, mcp:Implementation info = {name: "MCP", version: "1.0.0"},
            *mcp:StreamableHttpClientTransportConfig config) returns ai:Error? {
        do {
            self.mcpClient = check new mcp:StreamableHttpClient(serverUrl, config);
            self.tools = check ai:getPermittedMcpToolConfigs(self.mcpClient, info, self.callTool).cloneReadOnly();
        } on fail error e {
            return error ai:Error("Failed to initialize MCP toolkit", e);
        }
    }

    public isolated function getTools() returns ai:ToolConfig[] => self.tools;

    @ai:AgentTool
    public isolated function callTool(ai:Context ctx, mcp:CallToolParams params) returns mcp:CallToolResult|error {
        string authorization = check ctx.getWithType(AUTHORIZATION_CONTEXT_KEY);
        return self.mcpClient->callTool(params, {"Authorization": authorization});
    }
}

