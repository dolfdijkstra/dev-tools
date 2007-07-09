package com.fatwire.cs.support.tools;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;

import com.fatwire.cs.catalogmover.mover.BaseCatalogMover;
import com.fatwire.cs.catalogmover.mover.CatalogMoverException;
import com.fatwire.cs.catalogmover.mover.CatalogMoverImpl;
import com.fatwire.cs.catalogmover.mover.HttpAccessTransporter;
import com.fatwire.cs.catalogmover.mover.LocalCatalog;
import com.fatwire.cs.catalogmover.mover.commands.MoveCatalogCommand;

/**
 * Imports a catalog into ContentServer
 * 
 * @author Dolf.Dijkstra
 * @since 9-mei-2007
 * @goal import
 */
public class ImportMojo extends AbstractCatalogMoverMojo {

    /**
     * 
     */
    public ImportMojo() {
        super();
    }

    public void doExecute() throws URISyntaxException, IOException,
            CatalogMoverException {

        HttpAccessTransporter transporter = new HttpAccessTransporter();

        transporter.setCsPath(url.toURI());
        transporter.setUsername(username);
        transporter.setPassword(password);
        transporter.init();
        final BaseCatalogMover cm = new CatalogMoverImpl(transporter);
        for (String catalog : catalogs) {
            final File f = new File(populateDirectory, catalog + ".html");

            final LocalCatalog localCatalog = new LocalCatalog(f);
            localCatalog.refresh();
            MoveCatalogCommand command = new MoveCatalogCommand(cm, localCatalog,
                    getMonitor());
            command.execute();
        }

    }

}
