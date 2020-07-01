package stepdefinitions;

import io.cucumber.java.Before;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import org.junit.Assert;
import protocolhandling.IProtocolHandler;
import protocolhandling.ProtocolHandlerFactory;
import utils.DateChecker;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.equalTo;


public class CommonStepDefinitions {
    // enables easy switching between different IProtocolHandler implementations. Can be steered by 'protocol' property. Since
    // currently only REST communication is available, if no property is defined it defaults to REST.
    private IProtocolHandler protocol = ProtocolHandlerFactory.createHandler(System.getProperty("protocol"));

    @Before
    public void prepareNewRequest(){
        protocol.prepareNewRequest();
    }

    @Given("I want to call {string} method")
    public void setTargetURIToBeCalled(String method) {
        protocol.setTargetURIToBeCalled("https://api.ratesapi.io/api/"+method);
    }

    @Given("use {string} symbols")
    public void useSymbols(String symbols) {
        protocol.addRequestParameter("symbols", symbols);
    }

    @Given("use {string} as a base")
    public void useBase(String base) {
        protocol.addRequestParameter("base", base);
    }

    @When("I send GET request")
    public void sendGetRequest() {
        protocol.sendGetRequest();
    }

    @Then("status of the response is {int}")
    public void getResponseStatusCode(int status) {
        Assert.assertEquals("Wrong status code returned.", status, protocol.getResponseStatusCode());
    }

    @Then("properly formatted successful response in received")
    public void properlyFormattedSuccessfulResponseInReceived() {
        boolean validationStatus = false;
        String validationMessage = "";
        try {
            validationStatus = protocol.validateResponseConformsWithSchema("./schemas/successfulResponse.json");
        } catch (java.lang.AssertionError assertionError) { //catch and handled here - better visibility and no hidden assertions in the code
            validationMessage = assertionError.getMessage();
        }
        Assert.assertTrue(validationMessage, validationStatus);
    }

    @Then("properly formatted error response in received")
    public void properlyFormattedErrorResponseInReceived() {
        boolean validationStatus = false;
        String validationMessage = "";
        try {
            validationStatus = protocol.validateResponseConformsWithSchema("./schemas/errorResponse.json");
        } catch (java.lang.AssertionError assertionError) { //catch and handled here - better visibility and no hidden assertions in the code
            validationMessage = assertionError.getMessage();
        }
        Assert.assertTrue(validationMessage, validationStatus);
    }

    @Then("response contains all requested {string}")
    public void responseContainsAllRequestedSymbols(String symbols) {
        boolean validationStatus = false;
        String validationMessage = "";
        for (String symbol : symbols.split(",")) {
            try {
                validationStatus = protocol.validateResponseData("rates." + symbol, org.hamcrest.Matchers.notNullValue());
            } catch (AssertionError assertionError) { //catch and handled here - better visibility and no hidden assertions in the code
                validationMessage = assertionError.getMessage();
            }
            Assert.assertTrue(validationMessage, validationStatus);
        }
    }

    @Then("base is properly set to {string}")
    public void baseIsProperlySetTo(String base) {
        boolean validationStatus = false;
        String validationMessage = "";
        if (base.equals("")) base="EUR";
        try {
            validationStatus = protocol.validateResponseData("base", equalTo(base));
        } catch (AssertionError assertionError) { //catch and handled here - better visibility and no hidden assertions in the code
            validationMessage = assertionError.getMessage();
        }
        Assert.assertTrue(validationMessage, validationStatus);
    }

    @Then("returned date is set to {string}")
    public void returnedDateIsSetTo(String date) {
        Assert.assertTrue("provided date is expected to be real date and in YYYY-MM-DD format. Actual: "+date, DateChecker.isDateInValidFormat(date,"yyyy-MM-dd"));
        boolean validationStatus = false;
        String validationMessage = "";
        try {
            validationStatus = protocol.validateResponseData("date", equalTo(date));
        } catch (AssertionError assertionError) { //catch and handled here - better visibility and no hidden assertions in the code
            validationMessage = assertionError.getMessage();
        }
        Assert.assertTrue(validationMessage, validationStatus);
    }

    @Then("error message contains {string}")
    public void errorMessageContains(String message) {
        boolean validationStatus = false;
        String validationMessage = "";
        try {
            validationStatus = protocol.validateResponseData("error", containsString(message));
        } catch (AssertionError assertionError) { //catch and handled here - better visibility and no hidden assertions in the code
            validationMessage = assertionError.getMessage();
        }
        Assert.assertTrue(validationMessage, validationStatus);
    }

    @Then("returned date is valid")
    public void returnedDateIsValid() {
        String date = protocol.getResponseData("date");
        Assert.assertNotNull("Date node was not found in response data.", date);
        Assert.assertTrue("Returned date is not in YYYY-MM-DD format. Actual: "+ date, DateChecker.isDateInValidFormat(date,"yyyy-MM-dd"));
    }
}