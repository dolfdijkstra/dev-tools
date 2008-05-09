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

import com.fatwire.cs.catalogmover.mover.IProgressMonitor;

public abstract class AbstractCatalogMoverMojo extends AbstractMojo {

    /**
     * @parameter default-value="http://localhost:8080/cs/CatalogManager"
     * @required
     */
    protected URL url;

    public abstract void doExecute() throws Exception;

    protected void initLog4J() {
        AppenderSkeleton appender = new AppenderSkeleton() {

            @Override
            protected void append(LoggingEvent event) {

                int level = event.getLevel().toInt();

                if (level == Level.TRACE_INT) {
                    getLog().debug(String.valueOf(event.getMessage()));

                } else if (level == Level.DEBUG_INT) {
                    getLog().debug(String.valueOf(event.getMessage()));
                } else if (level == Level.INFO_INT) {
                    getLog().info(String.valueOf(event.getMessage()));
                } else if (level == Level.WARN_INT) {
                    getLog().warn(String.valueOf(event.getMessage()));
                } else if (level == Level.ERROR_INT) {
                    getLog().error(String.valueOf(event.getMessage()));
                } else if (level == Level.FATAL_INT) {
                    getLog().error(String.valueOf(event.getMessage()));
                } else {
                    getLog().info(String.valueOf(event.getMessage()));
                }
                
                if (event.getThrowableInformation() != null) {
                    getLog().info(
                            event.getThrowableInformation().getThrowable());
                }
            }

            @Override
            public void close() {

            }

            @Override
            public boolean requiresLayout() {
                return false;
            }

        };
        //appender.setLayout(new PatternLayout("%-5p [%-10t]: %m%n"));
        appender.setName("maven-appender");
        appender.activateOptions();
        Logger.getRootLogger().addAppender(appender);

        if (getLog().isDebugEnabled()) {
            Logger.getRootLogger().setLevel(Level.DEBUG);
            Logger.getLogger("com.fatwire").setLevel(Level.TRACE);
        } else if (getLog().isInfoEnabled()) {
            Logger.getRootLogger().setLevel(Level.INFO);
            Logger.getLogger("com.fatwire").setLevel(Level.INFO);
        } else if (getLog().isWarnEnabled()) {
            Logger.getRootLogger().setLevel(Level.WARN);
            Logger.getLogger("com.fatwire").setLevel(Level.WARN);
        } else if (getLog().isErrorEnabled()) {
            Logger.getRootLogger().setLevel(Level.ERROR);
            Logger.getLogger("com.fatwire").setLevel(Level.ERROR);
        } else {
            Logger.getRootLogger().setLevel(Level.OFF);
            Logger.getLogger("com.fatwire").setLevel(Level.OFF);
        }

    }

    protected void shutdownLog4J() {
        LogManager.resetConfiguration();
    }

    /**
     * @parameter default-value="fwadmin"
     * @required
     */
    protected String username;

    /**
     * @parameter default-value="xceladmin"
     * @required
     */
    protected String password;

    /**
     * Single directory that contains the catalog files.
     *
     * @parameter expression="${basedir}/src/main/Populate"
     * @required
     */
    protected File populateDirectory;

    /**
     * The list of catalog to be imported.
     * 
     * @parameter 
     * @required
     */
    protected List<String> catalogs;

    public AbstractCatalogMoverMojo() {
        super();
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

    protected IProgressMonitor getMonitor() {
        return new IProgressMonitor() {
            private String task;

            public void beginTask(final String string, final int i) {
                task = string;
                getLog().info("Starting task " + string);

            }

            public boolean isCanceled() {
                return false;
            }

            public void subTask(final String string) {
                getLog().debug(string);
            }

            public void worked(final int i) {
                getLog().debug(" task " + task + " has worked " + i);
            }

        };

    }

    public final void execute() throws MojoExecutionException, MojoFailureException {
        initLog4J();

        try {
            doExecute();
        } catch (final Exception e) {
            throw new MojoFailureException(this, e.getMessage(), e.getMessage());
        } finally {
            this.shutdownLog4J();
        }

    }

}