package protocolhandling;

import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import org.hamcrest.Matcher;

import static io.restassured.RestAssured.given;
import static io.restassured.module.jsv.JsonSchemaValidator.matchesJsonSchemaInClasspath;

// implementation of IProtocolHandler using rest-assured library
// purpose of each method described in IProtocolHandler file
public class RestHandler implements IProtocolHandler {

    private RequestSpecification request;
    private Response response;

    public RestHandler()
    {
        request=given();
    }

    @Override
    public void prepareNewRequest()
    {
        request = given();
    }

    @Override
    public void setTargetURIToBeCalled(String uri)
    {
        request.baseUri(uri);
    }

    @Override
    public void sendGetRequest()
    {
        response = request.get();
    }

    @Override
    public int getResponseStatusCode()
    {
        return response.statusCode();
    }

    @Override
    public void addRequestParameter(String name, String value) {
        request.param(name, value);
    }

    @Override
    public String getResponseData(String node) {
        return response.then().extract().path(node);
    }

    @Override
    public boolean validateResponseConformsWithSchema(String schemaName) throws AssertionError {
        //this way of checking schema is convenient, however it means AssertionError can be thrown from here.
        //therefore, method has been marked appropriately, so that exception could be catch and properly handled in step definition
        response.then().assertThat().body(matchesJsonSchemaInClasspath(schemaName));
        return true;
    }

    @Override
    public boolean validateResponseData(String node, Matcher<?> matcher) throws AssertionError{
        //this way of checking schema is convenient, however it means AssertionError can be thrown from here.
        //therefore, method has been marked appropriately, so that exception could be catch and properly handled in step definition
        response.then().body(node, matcher);
        return true;
    }

}
