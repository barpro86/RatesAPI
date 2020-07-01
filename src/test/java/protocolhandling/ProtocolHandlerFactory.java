package protocolhandling;

public class ProtocolHandlerFactory {

    // Basically a factory class that enables easy switching between different IProtocolHandler implementations.
    // So for example, if at any point we'd like to add SOAP handling, all that needs to be done is create class handling SOAP connections,
    // have it implement IProtocolHandler and then attach the class to this factory. No change in features/step definitions required.

    public static IProtocolHandler createHandler(String type) {
        if (type==null) {
            return new RestHandler(); //use REST by default
        } else if (type.equalsIgnoreCase("rest")) {
            return new RestHandler();
        } else if (type.equalsIgnoreCase("soap")) {
            //for future use
            return null;
        } else {
            throw new IllegalArgumentException("Unknown protocol type: " + type);
        }
    }

}
