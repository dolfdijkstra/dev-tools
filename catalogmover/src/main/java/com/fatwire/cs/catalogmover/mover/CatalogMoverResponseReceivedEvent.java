package com.fatwire.cs.catalogmover.mover;

import com.fatwire.cs.core.http.Response;

public class CatalogMoverResponseReceivedEvent extends CatalogMoverEvent {
    /**
     * 
     */
    private static final long serialVersionUID = 2156377120752609111L;

    private final SimpleResponse body;

    private final Response response;

    public CatalogMoverResponseReceivedEvent(AbstractCatalogMover mover,
            Response response) {
        this(mover, response, null);

    }

    public CatalogMoverResponseReceivedEvent(AbstractCatalogMover mover,
            Response response, SimpleResponse body) {
        super(mover);
        this.response = response;
        this.body = body;

    }

    /**
     * @return the body
     */
    public SimpleResponse getBody() {
        return body;
    }

    /**
     * @return the response
     */
    public Response getResponse() {
        return response;
    }

}
