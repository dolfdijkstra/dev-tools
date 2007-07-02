package com.fatwire.cs.catalogmover.mover.commands;

import java.io.File;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.fatwire.cs.catalogmover.mover.BaseCatalogMover;
import com.fatwire.cs.catalogmover.mover.CatalogMoverException;
import com.fatwire.cs.catalogmover.mover.IProgressMonitor;
import com.fatwire.cs.catalogmover.mover.RemoteCatalog;

public class ExportMultipleCatalogsCommand extends AbstractCatalogMoverCommand {
    private final static Log log = LogFactory
    .getLog(ExportMultipleCatalogsCommand.class);

    final Iterable<String> catalogs;

    final File exportPath;

    final IProgressMonitor monitor;

    public ExportMultipleCatalogsCommand(BaseCatalogMover cm,
            Iterable<String> catalogs, File exportPath,
            final IProgressMonitor monitor) {
        super(cm);
        this.catalogs = catalogs;
        this.exportPath = exportPath;
        this.monitor = monitor;
    }

    @Override
    public void execute() throws CatalogMoverException {
        for (String name : catalogs) {

            RemoteCatalog rc = new RemoteCatalog(name, this.exportPath);
            ExportCatalogCommand command = new ExportCatalogCommand(catalogMover, rc,
                    monitor);
            try {
                command.execute();
            } catch (Exception e) {
                log.error("Exception exporting catalog " + name, e);
            }
            monitor.worked(1);
        }

    }

}
