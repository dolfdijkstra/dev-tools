package com.fatwire.cs.catalogmover.util;

import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.StringTokenizer;

import org.apache.commons.codec.DecoderException;
import org.apache.commons.codec.net.URLCodec;
import org.apache.commons.logging.LogFactory;

public class StringUtils {

    public static boolean goodString(final String s) {
        return s != null && s.length() > 0;
    }

    public static final Collection<String> arguments(String cmd, int sep) {
        byte data[] = { (byte) '\0' };
        data[0] = (byte) sep;
        String str = new String(data);
        return arguments(cmd, str);
    }

    public static final List<String> arguments(String cmd, String sep) {
        List<String> v = new LinkedList<String>();
        arguments(v, cmd, sep);
        return v;
    }

    // A simplistic tokenizer that can deal with
    // seperator strings and produces a vector
    // of substrings.
    //
    // StringTokenizer doesn't work since it requires a
    // token and this doesn't
    public static final Collection<String> arguments(Collection<String> v,
            String cmd, String sep) {
        try {
            StringTokenizer tokenizer = new StringTokenizer(cmd, sep, false);
            while (tokenizer.hasMoreTokens()) {
                // tokenizer returns true always at least
                // once, so watch out for dead string
                String s = tokenizer.nextToken().trim();
                if (!emptyString(s))
                    v.add(s);
            }
        } catch (NoSuchElementException exception) {
            LogFactory.getLog(StringUtils.class).error(
                    "NoSuchElementException creating a list from " + cmd,
                    exception);
        } catch (StringIndexOutOfBoundsException exception) {
            LogFactory.getLog(StringUtils.class).error(
                    "StringIndexOutOfBoundsException creating a list from "
                            + cmd, exception);
        }
        return v;
    }

    public static final boolean emptyString(String x) {
        // if the string is null, return true==empty
        if (x == null)
            return true;

        int len = x.length();
        for (int i = 0; i < len; i++) {
            if (!Character.isWhitespace(x.charAt(i)))
                return false;
        }

        return true;
    }

    /**
     * Build a map of parameters given input in the form of "a=b&c=d..."
     *
     * @param inputParam in The input string containing the parameters.
     * @param map        The output map of key/value pairs
     * @param bDecode    true to indicate that decoding is desired
     * @since 4.0
     */
    public static final void seedTo(String inputParam, Map<String, String> map,
            boolean bDecode) {
        if (emptyString(inputParam))
            return;

        int iequal, iamper;
        int startAt = 0;
        int inlen = inputParam.length();
        boolean bDone = false;

        while (!bDone) {
            String n, v;
            if ((iequal = inputParam.indexOf('=', startAt)) != -1) {
                // End of current name=value is '&' or EOL
                iamper = inputParam.indexOf('&', iequal);
                n = inputParam.substring(startAt, iequal).trim();
                iequal++;
                if (iequal >= inlen)
                    break;

                if (iamper == -1)
                    v = inputParam.substring(iequal);
                else
                    v = inputParam.substring(iequal, iamper);

                if (iamper != -1)
                    startAt = iamper + 1;
                else
                    bDone = true;

                // deal with stupid value
                v = v.trim();
                if (bDecode) {
                    try {
                        n = decode(n);
                        v = decode(v);
                    } catch (Exception exception) {
                    }
                }
                map.put(n, v);
            } else
                break; // no more pairs
        }

    }

    private static String PLATFORM_DEFAULT_CHARSET = Charset.defaultCharset()
            .name();

    private static URLCodec APACHE_COMMONS_CODEC = new URLCodec(
            PLATFORM_DEFAULT_CHARSET);

    private static String decode(String n) {
        try {
            return APACHE_COMMONS_CODEC.decode(n, PLATFORM_DEFAULT_CHARSET);
        } catch (UnsupportedEncodingException e) {
            throw new IllegalStateException(
                    "Platform default encoding is not supported??? ", e);
        } catch (DecoderException e) {
            throw new RuntimeException(e);
        }
    }

}