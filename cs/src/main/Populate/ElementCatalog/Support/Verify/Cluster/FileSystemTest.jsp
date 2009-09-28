<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%//
// Support/Verify/Cluster/FileSystemTest
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="java.io.*"
%><%@ page import="java.util.concurrent.*"
%><%!
class TestFS
{

    private Integer numThreads;
    private File dir;
    private Integer numFiles;
    private Integer fileSize;
    private Integer numReads;

    public TestFS(int numThreads, File path, int numFiles, int fileSize, int numReads)
    {
        this.numThreads = Integer.valueOf( numThreads );
        this.dir = new File(path, "threads");
        this.numFiles = Integer.valueOf( numFiles );
        this.fileSize = Integer.valueOf( fileSize );
        this.numReads = Integer.valueOf( numReads );
        dir.mkdirs();
    }

    public long[] runTest()
    {
        //System.out.println("Testing File System with " + this.numThreads + " threads, " + this.numFiles + " files, "
        //                    + this.fileSize + " bytes of data/file, " + this.numReads + " reads/file." );

        // Create a subDir in path to be deleted at end

        ExecutorService service = Executors.newFixedThreadPool( this.numThreads );

        long startTime = System.currentTimeMillis();

        long[] threadTimes = new long[this.numThreads];
        Future<Long>[] futures = new Future[this.numThreads];
        for( int x = 0; x < this.numThreads; x++ )
        {
            threadTimes[x] = -1;
        }

        for( int x = 0; x < this.numThreads; x++ )
        {
            //Get the threadTime returned from call()
            futures[x] = service.submit( new FileAccessCallable( this.dir, this.numFiles, this.fileSize, this.numReads ) );
        }
        for( int x = 0; x < this.numThreads; x++ )
        {
            try
            {
                threadTimes[x] = futures[x].get();
            }
            catch(ExecutionException e)
            {
                System.out.println(e.getMessage());
            }
            catch(InterruptedException e)
            {
                System.out.println(e.getMessage());
            }
        }

        try
        {
            service.shutdown();
            service.awaitTermination( 60*60, TimeUnit.SECONDS );
        }
        catch (InterruptedException e)
        {
            // todo: handle e properly
            System.err.println(e);
            e.printStackTrace();
        }

        long maxTime = 0;
        long minTime = Integer.MAX_VALUE;
        long totalTime = 0;
        int runs = 0;

        //Get max, min, totalTimes
        for( int i = 0; i < threadTimes.length; i++ )
        {
            long threadTime = threadTimes[i];
            if( threadTime != -1)
            {
                runs++;
                minTime = Math.min(threadTime,minTime);
                maxTime = Math.max(threadTime,maxTime);;

                totalTime += threadTime;
            }
        }

        //Clean up thread directories
        for (File threadDir : dir.listFiles())
        {
            threadDir.delete();
        }
        dir.delete();

        //Get average time
        long averageTime = totalTime / ( runs == 0 ? 1:runs );
        long runTime = System.currentTimeMillis() - startTime;
        /*
        System.out.println( "" );
        System.out.println( "Run time " + ( runTime) );
        System.out.println( "Total time " + ( totalTime ) );
        System.out.println( "Shortest time " + ( minTime ) );
        System.out.println( "Longest time " + ( maxTime ) );
        System.out.println( "Average time " + ( averageTime ) );
        */
        long[] results = { minTime,maxTime,averageTime,totalTime,runTime };

        return results;
    }


}
    private static class FileAccessCallable implements Callable<Long>
    {
        private File path;
        private int numFiles;
        private int fileSize;
        private int numReads;

        FileAccessCallable( File path, int numFiles, int fileSize, int numReads )
        {
            this.path = path;
            this.numFiles = numFiles;
            this.fileSize = fileSize;
            this.numReads = numReads;
        }


        public Long call()
        {
            String s = Thread.currentThread().getName();



            // First create the subDir in path
            File dir = new File( path , s );
            dir.mkdirs();
            StringBuilder sb = new StringBuilder();

            // Create a String of given size (bytes)
            for ( int i = 0; i < fileSize; i++)
            {
                sb.append(",");
            }
            byte[] b = sb.toString().getBytes();
            sb=null;
            long startTime = System.currentTimeMillis();
            try
            {
                // Create given # of files
                for( int x = 0; x < numFiles; x++ )
                {
                    File f = new File( dir, x + ".lock" );
                    f.createNewFile();
                    FileOutputStream os = new FileOutputStream( f );
                    os.write( b );
                    os.close();
                }

                // read these files using a RandomAccessFile
                for( int x = 0; x < numFiles; x++ )
                {
                    // read them a given # of times
                    for( int i = 0; i < numReads; i++ )
                    {
                        RandomAccessFile ra = new RandomAccessFile( new File(dir , x + ".lock"), "rws" );
                        ra.readFully(b);
                        ra.close();
                        //System.out.println( s + " read " + ( x )  );

                    }
                }


                // delete

                for( int x = 0; x < numFiles; x++ )
                {
                    File delFile = new File( dir, x + ".lock" );
                    if( delFile.exists() )
                    {
                        delFile.delete();
                    }
                }

            }

            catch( Exception ex )
            {
                ex.printStackTrace();
            }

            long runTime = System.currentTimeMillis() - startTime;
            //System.out.println( s + " time=" + ( runTime )  );

            return runTime;
        }
    }

%><cs:ftcs><%
int numThreads = Integer.parseInt(ics.GetVar("numThreads"));
int numFiles = Integer.parseInt(ics.GetVar("numFiles"));
int fileSize = Integer.parseInt(ics.GetVar("fileSize"));
int numReads = Integer.parseInt(ics.GetVar("numReads"));
String where = ics.GetVar("type") ==null?"local":ics.GetVar("type");

//File dir = new File("/tmp");

String dir= ((File)(getServletConfig().getServletContext().getAttribute("javax.servlet.context.tempdir"))).toString();

if ("sync".equals(where)){
    dir = ics.GetProperty("ft.usedisksync");
} else if ("spc".equals(where)){
    dir = ics.ResolveVariables("CS.CatalogDir.SystemPageCache");
} else if ("data".equals(where)){
    dir = ics.ResolveVariables("CS.CatalogDir.MungoBlobs");
}


if (dir == null || dir.length()==0 ) {
    %>boohoo, no dir <%
}else {
    final File path = new File(dir, "TestFS-can-be-removed");

    TestFS testFS = new TestFS(numThreads, path, numFiles, fileSize, numReads);
    long[] results = testFS.runTest();
    ics.SetObj("testFSresults",results);
    %>{where:'<%=where%>',
    minTime:<%=Long.toString(results[0])%>,
    maxTime:<%=Long.toString(results[1])%>,
    averageTime:<%=Long.toString(results[2])%>,
    totalTime:<%=Long.toString(results[3])%>,
    runTime:<%=Long.toString(results[4])%>}<%
    path.delete();
}
%></cs:ftcs>