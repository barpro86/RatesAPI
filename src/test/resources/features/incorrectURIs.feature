Feature: General non-working API calls


Scenario Outline: Asserting correct response for non-working API calls
  Given I want to call "<method>" method
  When I send GET request
  Then status of the response is 400
  And properly formatted error response in received
  And error message contains "<message>"
  Examples:
    | method            | message                                             |
    | nonExistingMethod | time data 'nonExistingMethod' does not match format |
    |                   | time data 'api' does not match format               |
