import ballerina/ai;
import ballerina/http;

listener http:Listener chatAgentListener = check http:getDefaultListener();

service /ai\-agent on chatAgentListener {
    resource function post chat(@http:Payload ai:ChatReqMessage request, @http:Header string authorization = "Bearer foo") returns ai:ChatRespMessage|error {
        ai:Context ctx = new ai:Context();
        ctx.set(AUTHORIZATION_CONTEXT_KEY, authorization);
        string stringResult = check aiAgent.run(request.message, request.sessionId, ctx);
        return {message: stringResult};
    }
}
