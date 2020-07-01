# DESCRIPTION:

Basic BDD framework for calling API. Mainly uses Java, Cucumber, RestAssured. At the moment only Rest communication is
but SOAP can be easily added. Check ProtocolHandlerFactory and CommonStepDefinitions for more details on that.  

## Running

```
mvn clean test -Dprotocol=rest
``` 
At the moment -Dprotocol part can be ommited.

## Disclaimers

I was mainly focused on code's structure and design, and while main business logic behind the API calls is tested, it could probably 
be improved in some places. Resulting code is however fairly easy to read, develop and maintenance, I think, and follows good coding practices & principles. 
I have tried to design gherkin steps so that they are self-explanatory and easy to read, while being robust at the same time.

Both Latest and Specific Date responses share the same schema, so I decided not to create separate json for each of them, just to keep things simple.
This can be very easily done however, should the need ever arise. Same goes for naming json schemas, in case more requests are available, they (jsons) should
probably contain name of the request they represent, but for now they are enough (again, keeping things simple).

Lastly, I am a bit confused about the logic behind returning 'date' field's value. Last acceptance criteria point specifically says
that any date from future should result in 'current day' date which I find is simply NOT true. At the time of writing this any calls 
for future or indeed today's dates result in 'current day -1' date. My initial assumption is that this is probably connected to 
current time (idea being until certain time API return yesterdays data [markets still open maybe?], and after certain time
API indeed returns 'current day' data [markets closed?]) - but I would have to know more (mainly specific time and timezone of
when the switch happens) to implement it properly. So for know I am simply checking if the returned date is valid (meaning 
format is ok and it represents existing date).