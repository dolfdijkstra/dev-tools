<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%
//
// Support/Info/ThreadDump
//
// INPUT
//
// OUTPUT
//
%><%@ page import="java.lang.management.ManagementFactory"
%><%@ page import="java.lang.management.ThreadInfo"
%><%@ page import="java.lang.management.ThreadMXBean"
%><%!
private final ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();


private static final char[] INDENT = "    ".toCharArray();

private static final char[] NEW_LINE = "\r\n".toCharArray();


void createThreadDump(StringBuilder sb, int max, boolean runningOnly) {
    ThreadInfo[] threadInfos;
    threadInfos = threadMXBean.getThreadInfo(
            threadMXBean.getAllThreadIds(), max);

    for (ThreadInfo threadInfo : threadInfos) {
        printThreadInfo(threadInfo, sb,runningOnly);
    }

}

private void printThreadInfo(ThreadInfo ti, final StringBuilder sb, boolean runningOnly) {
    if (runningOnly && ti.getThreadState() != Thread.State.RUNNABLE) return;
    long tid = ti.getThreadId();
    sb.append("\"").append(ti.getThreadName()).append("\"").append(" id=").append(tid).append(" in "
           ).append(ti.getThreadState());
    if (ti.getLockName() != null) {
        sb.append(" on lock=").append(ti.getLockName());
    }
    if (ti.isSuspended()) {
        sb.append(" (suspended)");
    }
    if (ti.isInNative()) {
        sb.append(" (running in native)");
    }
    if (ti.getLockOwnerName() != null) {
        sb.append(INDENT).append(" owned by ")
                .append(ti.getLockOwnerName()).append(" id=").append(
                        ti.getLockOwnerId());

    }
    if (threadMXBean.isThreadCpuTimeSupported()) {
        sb.append(NEW_LINE);
        sb.append(" total cpu time=")
                .append( formatNanos(threadMXBean.getThreadCpuTime(tid)));
        sb.append(", user time=").append(
                formatNanos(threadMXBean.getThreadUserTime(tid)));
    }

    if (threadMXBean.isThreadContentionMonitoringSupported() && threadMXBean.isThreadContentionMonitoringEnabled()){
        sb.append(NEW_LINE);
        sb.append(" blocked count=").append(ti.getBlockedCount());
        sb.append(", blocked time=").append(formatNanos(ti.getBlockedTime()));
        sb.append(", wait count=").append(ti.getWaitedCount());
        sb.append(", wait time=").append(formatNanos(ti.getWaitedTime()));
    }

    sb.append(NEW_LINE);
    for (StackTraceElement ste : ti.getStackTrace()) {
        sb.append(INDENT).append("at ").append(ste.toString());
        sb.append(NEW_LINE);
    }
    sb.append(NEW_LINE);

}

String formatNanos(long ns) {
    return String.format("%.2f ms", ns / 1000000D);
}
%>
<cs:ftcs><% if (threadMXBean.isThreadContentionMonitoringSupported()&& !threadMXBean.isThreadContentionMonitoringEnabled()){threadMXBean.setThreadContentionMonitoringEnabled(true);}
String m = ics.GetVar("maxStackTraceSize");
int max= Integer.MAX_VALUE;
boolean runningOnly = "true".equals(ics.GetVar("runningThreadsOnly"));
if (COM.FutureTense.Interfaces.Utilities.goodString(m)){
    try {
        max = Integer.parseInt(m);
    }catch(Exception e){
     //ignore
    }
}
StringBuilder str = new StringBuilder();
str.append("Full Thread Dump at ").append(new java.util.Date()).append(NEW_LINE);
createThreadDump(str,max,runningOnly);
out.write(str.toString());
%></cs:ftcs>