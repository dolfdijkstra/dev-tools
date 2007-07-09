package com.fatwire.cs.support.tools;

import java.net.URISyntaxException;

import com.fatwire.cs.catalogmover.mover.CatalogExporter;
import com.fatwire.cs.catalogmover.mover.CatalogMoverException;
import com.fatwire.cs.catalogmover.mover.IProgressMonitor;
import com.fatwire.cs.catalogmover.mover.PoolableHttpAccessTransporter;
import com.fatwire.cs.catalogmover.mover.commands.ExportAllCatalogsCommand;
import com.fatwire.cs.catalogmover.mover.commands.ExportMultipleCatalogsCommand;

/**
 * Exports catalogs from ContentServer
 * 
 * @author Dolf.Dijkstra
 * @since 2006-6-4
 * @goal export
 */
public class ExportMojo extends AbstractCatalogMoverMojo {

    /**
     * 
     */
    public ExportMojo() {
        super();
    }

    @Override
    public void doExecute() throws URISyntaxException, CatalogMoverException {
        final PoolableHttpAccessTransporter transporter = new PoolableHttpAccessTransporter();

        transporter.setCsPath(url.toURI());
        transporter.setUsername(username);
        transporter.setPassword(password);
        transporter.init();

        final CatalogExporter cm = new CatalogExporter(transporter);
        try {
            final IProgressMonitor monitor = getMonitor();
            if ((catalogs.size() == 1) && catalogs.contains("SystemInfo")) {

                monitor.beginTask("Exporting all catalogs", -1);

                final ExportAllCatalogsCommand command = new ExportAllCatalogsCommand(
                        cm, populateDirectory, monitor);
                command.execute();

            } else {
                final ExportMultipleCatalogsCommand command = new ExportMultipleCatalogsCommand(
                        cm, catalogs, populateDirectory, monitor);
                monitor.beginTask("Exporting multiple catalogs", -1);
                command.execute();
            }

        } finally {
            cm.close();

        }
    }
}
