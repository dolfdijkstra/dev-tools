<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><%
//
// Support/Verify/Cluster/TestFS
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
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.RandomAccessFile" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.concurrent.ExecutorService" %>
<%@ page import="java.util.concurrent.Executors" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="java.util.concurrent.atomic.AtomicLong" %>
<%!
Set test = new HashSet();
Set reports = new HashSet();

interface TimeReporter {
    void report(String runnableName, long time);

    void reportFailure(Exception e);
    Object[] getReport();
}

class FileSystem {
    final int numThreads;

    final String path;

    final int numFiles;

    private final byte[] data = "sssssdfjkahgsjklahgkljsdfhgksdfjhgkjlfhgkjldfhgkjhfdkjghfklsdjghdfjkhdfkljhgkldfjgh"
            .getBytes();

    boolean running=false;

    /**
     * @param numThreads
     * @param path
     * @param numFiles
     */
    public FileSystem(final int numThreads, final String path,
            final int numFiles) {
        super();
        this.numThreads = numThreads;
        this.path = path;
        this.numFiles = numFiles;
    }

    Object[] doWork() {

        final ExecutorService service = Executors
                .newFixedThreadPool(numThreads);

        final TimeReporter reporter = new TimeReporter() {
            int totalReports = 0;

            final AtomicLong totalTime = new AtomicLong();

            final Date startTime = new Date();

            public void report(String runnableName, long time) {
                totalReports++;
                totalTime.addAndGet(time);

                //System.out.println(runnableName + " time=" + time);

            }

            public void reportFailure(Exception e) {
                System.err.println(e.getMessage());
                e.printStackTrace();

            }

            /* (non-Javadoc)
             * @see java.lang.Object#toString()
             */
            @Override
            public String toString() {
                return new StringBuilder("totalTime: ").append(
                        this.totalTime.get()).append(", totalReports: ")
                        .append(totalReports).toString();

            }
            public Object[] getReport() { return new Object[] {startTime,totalTime.get(),totalReports,numThreads,path,numFiles};}

        };
        final long startTime = System.currentTimeMillis();

        for (int x = 0; x < numThreads; x++) {
            service.submit(new FileAccessRunnable("worker-" + x, reporter));
        }

        try {
            service.shutdown();
            service.awaitTermination(60 * 60, TimeUnit.SECONDS);
        } catch (final InterruptedException e) {
            // todo: handle e properly
            System.err.println(e);
            e.printStackTrace();
        }
        final long time = System.currentTimeMillis() - startTime;
        Object[] i = reporter.getReport();
        Object[] r = new Object[i.length+1];
        r[0]=time;

        System.arraycopy(i, 0, r, 1, i.length);
        reports.add(r);
        return r;
    }


    private class FileAccessRunnable implements Runnable {

        private final TimeReporter reporter;

        private final String runnableName;

        final File dir;

        FileAccessRunnable(final String runnableName,
                final TimeReporter reporter) {
            this.runnableName = runnableName;
            this.reporter = reporter;
            // First create the subDir in path
            dir = new File(path, runnableName);


        }

        File getFile(int x) {
            return new File(dir, Integer.toString(x) + ".lock");
        }

        public void run() {
            dir.mkdirs();
            final long startTime = System.currentTimeMillis();

            try {
                // Create 100 files
                for (int x = 0; x < numFiles; x++) {
                    final File f = getFile(x);
                    f.createNewFile();
                    final FileOutputStream os = new FileOutputStream(f);
                    os.write(data);
                    os.close();
                }

                // read these files using a RandomAccessFile
                for (int x = 0; x < numFiles; x++) {
                    final RandomAccessFile ra = new RandomAccessFile(
                            getFile(x), "rws");
                    ra.close();
                }

                // read canonical path
                for (int x = 0; x < numFiles; x++) {
                    getFile(x).getCanonicalFile();
                }

                // delete
                for (int x = 0; x < numFiles; x++) {
                    final File delFile = getFile(x);
                    if (delFile.exists()) {
                        delFile.delete();
                    }
                }
            } catch (final Exception ex) {
                reporter.reportFailure(ex);

            }
            reporter.report(runnableName, System.currentTimeMillis()
                    - startTime);
        }
    }

}
%>
<cs:ftcs>
<%


        String syncDir = ics.GetProperty("ft.usedisksync");
        if (syncDir == null || syncDir.length() ==0) {
            %> boohoo, no synchdir <%
        }else {

            final File path = new File(syncDir, "TestFS");

            final Integer numThreads = ics.GetVar("t") ==null? Integer.valueOf("1") : Integer.valueOf(ics.GetVar("t")) ;
            final Integer numFiles = ics.GetVar("f") ==null? Integer.valueOf("100") : Integer.valueOf(ics.GetVar("f")) ;

            final FileSystem fs = new FileSystem(numThreads, path.toString(), numFiles);
            test.add(fs);
            Object[] report = fs.doWork();
            %>runTime: <%= String.valueOf(report[0]) %><br/><%
            %>startTime: <%= String.valueOf(report[1]) %><br/><%
            %>totalTime: <%= String.valueOf(report[2]) %><br/><%
            %>totalReports: <%= String.valueOf(report[3]) %><br/><%
            %>numThreads: <%= String.valueOf(report[4]) %><br/><%
            %>path: <%= String.valueOf(report[5]) %><br/><%
            %>numFiles: <%= String.valueOf(report[6]) %><br/><%



        }
%>
</cs:ftcs>