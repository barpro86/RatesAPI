Feature: Latest Foreign Exchange rates


Scenario Outline: Asserting success status of the response in positive cases
  Given I want to call "latest" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then status of the response is 200
  Examples:
  | symbols           | base |
  |                   |      |
  | PLN               |      |
  |                   | SEK  |
  |                   | EUR  |
  | EUR               | SEK  |
  | PLN,GBP           |      |
  | GBP,USD           | JPY  |
  | USD,JPY           | EUR  |
  | USD,EUR           | JPY  |

Scenario Outline: Asserting the response in positive cases
  Given I want to call "latest" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then properly formatted successful response in received
  And response contains all requested "<symbols>"
  And base is properly set to "<base>"
  And returned date is valid
  Examples:
    | symbols           | base |
    |                   |      |
    | PLN               |      |
    |                   | SEK  |
    |                   | EUR  |
    | EUR               | SEK  |
    | PLN,GBP           |      |
    | GBP,USD           | JPY  |
    | USD,JPY           | EUR  |
    | USD,EUR           | JPY  |

Scenario Outline: Asserting success status of the response in negative cases
  Given I want to call "latest" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then status of the response is <status>
  Examples:
  | symbols           | base    | status |
  | EUR               |         |  400   |
  | XYZ               |         |  400   |
  | tooLongSymbol     |         |  400   |
  |                   | XYZ     |  400   |
  |                   | XXYY    |  400   |
  |                   | JPY,USD |  400   |

Scenario Outline: Asserting the response in negative cases
  Given I want to call "latest" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then properly formatted error response in received
  And error message contains "<message>"
  Examples:
    | symbols           | base    | message                               |
    | EUR               |         | Symbols 'EUR' are invalid             |
    | XYZ               |         | Symbols 'XYZ' are invalid             |
    | tooLongSymbol     |         | Symbols 'tooLongSymbol' are invalid   |
    |                   | XYZ     | Base 'XYZ' is not supported.          |
    |                   | XXYY    | Base 'XXYY' is not supported.         |
    |                   | JPY,USD | Base 'JPY,USD' is not supported.      |