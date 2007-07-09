package com.fatwire.cs.catalogmover.mover;

import com.fatwire.cs.core.http.HostConfig;
import com.fatwire.cs.core.http.HttpAccess;
import com.fatwire.cs.core.http.HttpAccessException;
import com.fatwire.cs.core.http.Post;
import com.fatwire.cs.core.http.RequestState;
import com.fatwire.cs.core.http.Response;

public class HttpAccessTransporter extends AbstractHttpAccessTransporter
        implements Transporter {
    private HttpAccess httpAccess;


    protected HttpAccess getHttpAccess() {
        if (httpAccess == null) {
            if (getProxyHost() == null) {
                final HostConfig hc = new HostConfig(getCsPath());
                httpAccess = new HttpAccess(hc);
            } else {
                final HostConfig hc = new HostConfig(getCsPath().getHost(),
                        getCsPath().getPort(), getCsPath().getScheme(),
                        getProxyHost(), getProxyPort());
                httpAccess = new HttpAccess(hc);

            }
            final RequestState state = new RequestState();
            httpAccess.setState(state);

        }
        return httpAccess;
    }

    @Override
    public void close() {
        getHttpAccess().close();
    }

    @Override
    public synchronized Response execute(Post post) throws HttpAccessException {
        return getHttpAccess().execute(post);
    }

}
