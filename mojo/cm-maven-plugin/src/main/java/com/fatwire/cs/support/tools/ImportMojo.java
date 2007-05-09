package com.fatwire.cs.support.tools;

import java.io.File;
import java.net.URL;
import java.util.List;

import org.apache.log4j.AppenderSkeleton;
import org.apache.log4j.Level;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;
import org.apache.log4j.spi.LoggingEvent;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;

import com.fatwire.cs.catalogmover.mover.CatalogMover;
import com.fatwire.cs.catalogmover.mover.IProgressMonitor;
import com.fatwire.cs.catalogmover.mover.LocalCatalog;

/**
 * 
 * 
 * @author Dolf.Dijkstra
 * @since 9-mei-2007
 * @goal import
 */
public class ImportMojo extends AbstractMojo {

    /**
     * 
     */
    public ImportMojo() {
        super();
    }
    void initLog4J(){
        AppenderSkeleton appender = new AppenderSkeleton() {

            @Override
            protected void append(LoggingEvent event) {

                int level = event.getLevel().toInt();

                if (level == Level.TRACE_INT) {
                    ImportMojo.this.getLog().debug(
                            String.valueOf(event.getMessage()));
                    
                } else if (level == Level.DEBUG_INT) {
                    ImportMojo.this.getLog().debug(
                            String.valueOf(event.getMessage()));
                } else if (level == Level.INFO_INT) {
                    ImportMojo.this.getLog().info(
                            String.valueOf(event.getMessage()));
                } else if (level == Level.WARN_INT) {
                    ImportMojo.this.getLog().warn(
                            String.valueOf(event.getMessage()));
                } else if (level == Level.ERROR_INT) {
                    ImportMojo.this.getLog().error(
                            String.valueOf(event.getMessage()));
                } else if (level == Level.FATAL_INT) {
                    ImportMojo.this.getLog().error(
                            String.valueOf(event.getMessage()));
                } else {
                    ImportMojo.this.getLog().info(
                            String.valueOf(event.getMessage()));
                }
                if (event.getThrowableInformation()!=null){
                    ImportMojo.this.getLog().info(event.getThrowableInformation().getThrowable());
                }
            }

            @Override
            public void close() {

            }

            @Override
            public boolean requiresLayout() {
                // TODO Auto-generated method stub
                return false;
            }

        };
        //appender.setLayout(new PatternLayout("%-5p [%-10t]: %m%n"));
        appender.setName("maven-appender");
        appender.activateOptions();
        Logger.getRootLogger().addAppender(appender);
        Logger.getRootLogger().setLevel(Level.INFO);
        Logger.getLogger("com.fatwire").setLevel(Level.TRACE);

    }
    void shutdownLog4J(){
        LogManager.shutdown();
    }

    /**
     * @parameter default-value="http://localhost:8080/cs/CatalogManager"
     * @required
     */
    private URL url;

    /**
     * @parameter default-value="fwadmin"
     * @required
     */

    private String username;

    /**
     * @parameter default-value="xceladmin"
     * @required
     */

    private String password;

    /**
     * Single directory that contains the catalog files.
     *
     * @parameter expression="${basedir}/src/main/Populate"
     * @required
     */

    private File populateDirectory;

    /**
     * @parameter
     * @required
     */

    private List<String> catalogs;

    public void execute() throws MojoExecutionException, MojoFailureException {
        this.initLog4J();
        final CatalogMover cm = new CatalogMover();

        try {
            cm.setCsPath(url.toURI());
            cm.setUsername(username);
            cm.setPassword(password);
            for (String catalog : catalogs) {
                final File f = new File(populateDirectory, catalog + ".html");

                final LocalCatalog ec = new LocalCatalog(f);
                ec.refresh();
                cm.setCatalog(ec);

                cm.moveCatalog(new IProgressMonitor() {
                    private String task;

                    public void beginTask(final String string, final int i) {
                        task = string;
                        getLog().info("Starting task " + string);

                    }

                    public boolean isCanceled() {
                        return false;
                    }

                    public void subTask(final String string) {
                        getLog().info(string);
                    }

                    public void worked(final int i) {
                        getLog().info(" task " + task + " has worked " + i);
                    }

                });
            }
        } catch (final Exception e) {
            throw new MojoFailureException(this, e.getMessage(), e.getMessage());
        }finally{
            this.shutdownLog4J();
        }

    }

    /**
     * @return the catalogs
     */
    public List<String> getCatalogs() {
        return catalogs;
    }

    /**
     * @param catalogs the catalogs to set
     */
    public void setCatalogs(List<String> catalogs) {
        this.catalogs = catalogs;
    }

    /**
     * @return the password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password the password to set
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * @return the populateDirectory
     */
    public File getPopulateDirectory() {
        return populateDirectory;
    }

    /**
     * @param populateDirectory the populateDirectory to set
     */
    public void setPopulateDirectory(File populateDirectory) {
        this.populateDirectory = populateDirectory;
    }

    /**
     * @return the url
     */
    public URL getUrl() {
        return url;
    }

    /**
     * @param url the url to set
     */
    public void setUrl(URL url) {
        this.url = url;
    }

    /**
     * @return the username
     */
    public String getUsername() {
        return username;
    }

    /**
     * @param username the username to set
     */
    public void setUsername(String username) {
        this.username = username;
    }
}
