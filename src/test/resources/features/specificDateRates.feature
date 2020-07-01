Feature: Specific date Foreign Exchange rates

# While different dates are used in the request, most important here is to check that different parameter
# combinations return proper status code. Past/future/weekend permutations of specific date will have separate scenario
Scenario Outline: Asserting success status of the response in positive cases
  Given I want to call "<specific date>" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then status of the response is 200
  Examples:
    | specific date | symbols           | base |
    | 2010-01-13    |                   |      |
    | 2010-01-14    | PLN               |      |
    | 2010-01-15    |                   | SEK  |
    | 2010-01-16    |                   | EUR  |
    | 2010-01-17    | EUR               | SEK  |
    | 2010-01-18    | PLN,GBP           |      |
    | 2010-01-19    | GBP,USD           | JPY  |
    | 2010-01-20    | USD,JPY           | EUR  |
    | 2010-01-21    | USD,EUR           | JPY  |

# While different dates are used in the request, most important here is to check that different parameter
# combinations return proper response. Past/future/weekend permutations of specific date will have separate scenario
Scenario Outline: Asserting the response in positive cases
  Given I want to call "<specific date>" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then properly formatted successful response in received
  And response contains all requested "<symbols>"
  And base is properly set to "<base>"
  And returned date is valid
  And returned date is set to "<returned date>"
  Examples:
    | specific date | symbols           | base | returned date |
    | 2010-01-13    |                   |      | 2010-01-13    |
    | 2010-01-14    | PLN               |      | 2010-01-14    |
    | 2010-01-15    |                   | SEK  | 2010-01-15    |
    | 2010-01-16    |                   | EUR  | 2010-01-15    |
    | 2010-01-17    | EUR               | SEK  | 2010-01-15    |
    | 2010-01-18    | PLN,GBP           |      | 2010-01-18    |
    | 2010-01-19    | GBP,USD           | JPY  | 2010-01-19    |
    | 2010-01-20    | USD,JPY           | EUR  | 2010-01-20    |
    | 2010-01-21    | USD,EUR           | JPY  | 2010-01-21    |

# While different dates are used in the request, most important here is to check that different parameter
# combinations return proper status code. Past/future/weekend permutations of specific date will have separate scenario
Scenario Outline: Asserting success status of the response in negative cases
  Given I want to call "<specific date>" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then status of the response is <status>
  Examples:
    | specific date | symbols           | base    | status |
    | 2010-01-13    | EUR               |         |  400   |
    | 2010-01-14    | XYZ               |         |  400   |
    | 2010-01-15    | tooLongSymbol     |         |  400   |
    | 2010-01-16    |                   | XYZ     |  400   |
    | 2010-01-17    |                   | XXYY    |  400   |
    | 2010-01-18    |                   | JPY,USD |  400   |
    | 2010-40-50    |                   |         |  400   |
    | incorrectDate |                   |         |  400   |
    | 2010-40-50    | USD               |         |  400   |
    | 2010-40-50    |                   | PLN     |  400   |
    | 2010-40-50    | USD               | PLN     |  400   |

# While different dates are used in the request, most important here is to check that different parameter
# combinations return proper response. Past/future/weekend permutations of specific date will have separate scenario
Scenario Outline: Asserting the response in negative cases
  Given I want to call "<specific date>" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then properly formatted error response in received
  And error message contains "<message>"
  Examples:
    | specific date | symbols           | base    | message                                         |
    | 2010-01-13    | EUR               |         | Symbols 'EUR' are invalid                       |
    | 2010-01-14    | XYZ               |         | Symbols 'XYZ' are invalid                       |
    | 2010-01-15    | tooLongSymbol     |         | Symbols 'tooLongSymbol' are invalid             |
    | 2010-01-16    |                   | XYZ     | Base 'XYZ' is not supported.                    |
    | 2010-01-17    |                   | XXYY    | Base 'XXYY' is not supported.                   |
    | 2010-01-18    |                   | JPY,USD | Base 'JPY,USD' is not supported.                |
    | 2010-40-50    |                   |         | time data '2010-40-50' does not match format    |
    | incorrectDate |                   |         | time data 'incorrectDate' does not match format |
    | 2010-40-50    | USD               |         | time data '2010-40-50' does not match format    |
    | 2010-40-50    |                   | PLN     | time data '2010-40-50' does not match format    |
    | 2010-40-50    | USD               | PLN     | time data '2010-40-50' does not match format    |

# I couldn't find proper logic's description in the documentation, but from what I was able to find, following cases should be checked:
# - request for past monday-friday returns data from that day
# - request for past saturday returns data from closest friday
# - request for past sunday returns data from closest friday
# - *request for specific date set to today
# - *request for any future date returns data from today (unless today is saturday/sunday, then from closest friday)
#
#   * I am a bit confused, last acceptance criteria point specifically says that any date from future should result in 'current day' date
#     which I find is simply NOT true. At the time of writing this any calls for future or indeed today's dates result in 'current day -1' date.
#     My initial assumption is that this is probably connected to current time (idea being until certain time API return yesterdays data [markets still open maybe?]
#     , and after certain time API indeed returns 'current day' data [markets closed?]) - but I would have to know more (mainly specific time and timezone of
#     when the switch happens) to implement it properly. So for know I am simply checking if the returned date is valid (format is ok and it represents existing date).
Scenario Outline: Returned date logic validation
  Given I want to call "<specific date>" method
  And use "<symbols>" symbols
  And use "<base>" as a base
  When I send GET request
  Then properly formatted successful response in received
  And status of the response is 200
  And response contains all requested "<symbols>"
  And base is properly set to "<base>"
  And returned date is valid
  And returned date is set to "<returned date>"
  Examples:
    | specific date | symbols           | base | returned date |
    | 2020-03-27    |                   |      | 2020-03-27    |
    | 2020-03-28    | PLN               |      | 2020-03-27    |
    | 2020-03-29    |                   | SEK  | 2020-03-27    |

# THIS FAILS ON PURPOSE.
# commented out for successful build.
#
#Scenario Outline: Failure on purpose
#  Given I want to call "<specific date>" method
#  When I send GET request
#  Then properly formatted successful response in received
#  And returned date is valid
#  And returned date is set to "<returned date>"
#  Examples:
#    | specific date | returned date |
#    | 2010-11-13    | 9999-99-99    |
