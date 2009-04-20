<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// Support/Info/PerformanceStats
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.util.concurrent.ConcurrentHashMap"%>
<%@ page import="java.util.regex.MatchResult"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.util.Comparator"%>
<%@ page import="org.apache.log4j.AppenderSkeleton"%>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="org.apache.log4j.spi.LoggingEvent"%>

<%!

private Logger log = Logger.getLogger(StatisticsAppender.TIME_DEBUG);

static class StatisticsAppender extends AppenderSkeleton {
    static final String TIME_DEBUG = "com.fatwire.logging.cs.time";


    private Pattern pagePattern = Pattern
            .compile("Execute time  Hours: (\\d{1,}) Minutes: (\\d{1,}) Seconds: (\\d{1,}):(\\d{3})");

    private Pattern elementPattern = create("element", true);

    private Pattern preparedStatementPattern = create("prepared statement",
            false);

    private Pattern queryPattern = create("query", false); // select,insert,delete,update

    private Pattern updatePattern = create("update statement", true);

    private Pattern queryPatternWithDot = create("query", true);
    private static ConcurrentHashMap<String, Stat> stats = new ConcurrentHashMap<String, Stat>();

    public static Stat[] getStats() {
        synchronized (stats) {
            return stats.values().toArray(new Stat[0]);
        }
    }

    //@Override
    protected void append(LoggingEvent event) {
        if (event == null)
            return;
        if (TIME_DEBUG.equals(event.getLoggerName())) {
            // it's ours
            if (event.getMessage() != null) {
                try {
                    parseIt(String.valueOf(event.getMessage()));
                } catch(Exception e){
                    e.printStackTrace();
                }
            }
        }
    }

    //@Override
    public void close() {
        stats.clear();
    }

    //@Override
    public boolean requiresLayout() {
        return false;
    }

    private void parseIt(String s) throws Exception {

        long[] pr = this.pageResult(pagePattern.matcher(s));
        if (pr.length == 1) {
            update("page", pr[0]);
            return;
        }
        String[] r = result(elementPattern.matcher(s));
        if (r.length == 2) {
            update("element", r[0], Long.parseLong(r[1]));
            return;
        }
        r = result(preparedStatementPattern.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }
        r = result(queryPattern.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }
        r = result(queryPatternWithDot.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }
        r = result(updatePattern.matcher(s));
        if (r.length == 2) {
            update("sql", getStatementType(r[0]), Long.parseLong(r[1]));
            return;

        }

    }

    private void update(String type, String subType, long time) {
        String n = subType != null ? (type + "-" + subType) : type;
        Stat s = stats.get(n);
        if (s == null) {
            s = new Stat(type, subType);
            stats.put(n, s);

        }
        s.update(time);

    }

    private void update(String type, long time) {
        update(type, null, time);

    }

    private String getStatementType(String s) {

        int t = s == null ? -1 : s.trim().indexOf(" ");
        if (t != -1) {
            return s.substring(0, t).toLowerCase();
        }
        return "unknown";
    }

    private Pattern create(String type, boolean dot) {
        return Pattern.compile("Executed " + type + " (.+?) in (\\d{1,})ms"
                + (dot ? "." : ""));
    }

    private long[] pageResult(Matcher m) {
        long[] r = new long[0];
        if (m.matches()) {
            MatchResult mr = m.toMatchResult();
            if (mr.groupCount() == 4) {
                long t = Long.parseLong(mr.group(1)) * (3600000L);
                t += Long.parseLong(mr.group(2)) * (60000L);
                t += Long.parseLong(mr.group(3)) * (1000L);
                t += Long.parseLong(mr.group(4));
                r = new long[1];
                r[0] = t;

            }

        }
        return r;
    }

    private String[] result(Matcher m) {
        String[] r = new String[0];
        if (m.matches()) {
            MatchResult mr = m.toMatchResult();
            r = new String[mr.groupCount()];
            for (int i = 0; i < mr.groupCount(); i++) {
                r[i] = mr.group(i + 1);

            }
        }
        return r;
    }
}

static class Stat {
    private String type;
    private String subType;
    private long min = Long.MAX_VALUE;
    private long max = Long.MIN_VALUE;
    private int count = 0;
    private BigDecimal total = BigDecimal.valueOf(0);

    Stat(String type, String subType) {
        this.type = type;
        this.subType = subType;

    }

    synchronized void update(long t) {
        count++;
        total = total.add(BigDecimal.valueOf(t));
        min = Math.min(min, t);
        max = Math.max(max, t);

    }

    String getType() {
        return type;
    }

    String getSubType() {
        return subType;
    }

    long getMin() {
        return count == 0 ? 0 : min;
    }

    long getMax() {
        return count == 0 ? 0 : max;
    }

    int getCount() {
        return count;
    }

    void reset() {
        min = Long.MAX_VALUE;
        max = Long.MIN_VALUE;
        count = 0;
        total = BigDecimal.valueOf(0);
    }

    double getAverage() {
        if (count == 0)
            return Double.NaN;
        return total.divide(BigDecimal.valueOf(count), 2,
                BigDecimal.ROUND_HALF_UP).doubleValue();
    }
}

static class StatComparator implements Comparator<Stat>{
    public int compare(Stat m, Stat f){
        int c1= code(m);
        int c2=code(f);
        if(c1 < 6){
            return c1 - c2;
        }
        if (c2 < 6){
            return 1;
        }
        if (c1!=c2){
            return c1-c2;
        }
        if (m.getSubType() == null)         return -1;
        if (f.getSubType() == null)         return 1;
        //by now we are sql with unknown subtype, or element

        return m.getSubType().compareTo(f.getSubType());




    }
    String[] t = new String[]{"select","update","insert","delete"};
    private int code(Stat m){
        if ("page".equals(m.getType())){
            return 1;
        }else if ("sql".equals(m.getType())){
            for (int i=0;i<t.length;i++){
                if (t[i].equals(m.getSubType())){
                    return 2+i;
                }
            }
            return 6;
        } else if ("element".equals(m.getType())){
            return 7;
        }else {
            return 8;
        }

    }
}
%>
<cs:ftcs><%
if (log.getAppender("stats") == null) {
    //log.setAdditivity(false);
    StatisticsAppender a = new StatisticsAppender();
    a.setName("stats");
    a.activateOptions();
    log.addAppender(a);
    %>Enabled collecting of stats<br/><%
}else if ("true".equals(ics.GetVar("detach"))){
    log.removeAppender("stats");
}

Stat[] stats = StatisticsAppender.getStats();
java.util.Arrays.sort(stats, new StatComparator());

for (Stat stat:stats){
    %>type: <%=stat.getType() %>,<%
    %>subtype: <%=stat.getSubType() %>,<%
    %>count: <%=stat.getCount() %>,<%
    %>average: <%=stat.getAverage() %>,<%
    %>min: <%=stat.getMin() %>,<%
    %>max: <%=stat.getMax() %><%
    %><br/><%
}

%>

</cs:ftcs>