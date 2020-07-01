package protocolhandling;

import org.hamcrest.Matcher;

public interface IProtocolHandler {
    void prepareNewRequest(); //called before new request construction, in case implementing class needs to clear fields/data etc.
    void setTargetURIToBeCalled(String uri); //sets uri to be called when sending any request
    void sendGetRequest(); //send GET request in whatever state it may currently be
    int getResponseStatusCode(); //return status code of the response
    void addRequestParameter(String name, String value); //add specified parameter to the request
    String getResponseData(String node); //return value of specified node

    /*
    not the ideal way, but due to the time constrains it will have to do. Those kind of validations will most probably
    always be done using some 3rd party libraries that already throw AssertionErrors and I don't want to have any failing
    assertions 'deep' in the code, they all should be clearly defined in step definitions, hence all following
    methods throw AssertionErrors, which then can be handled in step definitions
    */
    boolean validateResponseConformsWithSchema(String schemaName) throws AssertionError; //validate the response against specified schema
    boolean validateResponseData(String node, Matcher<?> matcher) throws AssertionError; //validate specified node's value
}
