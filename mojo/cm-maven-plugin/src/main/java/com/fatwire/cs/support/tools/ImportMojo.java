package com.fatwire.cs.support.tools;

import java.io.File;
import java.net.URL;

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
     * @parameter
     * @required
     */
    private URL url;

    /**
     * @parameter default-value="http://localhost:8080/cs/CatalogManager"
     * @required
     */

    private String username;

    /**
     * @parameter default-value="fwadmin"
     * @required
     */

    private String password;

    /**
     * @parameter default-value="xceladmin"
     * @required
     * 
     */

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

    private String catalog;

    public void execute() throws MojoExecutionException, MojoFailureException {
        final CatalogMover cm = new CatalogMover();

        try {
            cm.setCsPath(url.toURI());
            cm.setUsername(username);
            cm.setPassword(password);

            final File f = new File(populateDirectory, catalog + ".html");

            final LocalCatalog ec = new LocalCatalog(f);
            ec.refresh();
            cm.setCatalog(ec);

            cm.moveCatalog(new IProgressMonitor() {
                private String task;

                public void beginTask(final String string, final int i) {
                    task = string;
                    getLog().info("begin task " + string);

                }

                public boolean isCanceled() {
                    return false;
                }

                public void subTask(final String string) {
                    getLog().info("begin sub task " + string);
                }

                public void worked(final int i) {
                    getLog().info(" task " + task + " has worked " + i);
                }

            });
        } catch (final Exception e) {
            throw new MojoFailureException(this, e.getMessage(), e.getMessage());
        }

    }
}
