package com.fatwire.cs.support.tools;

import java.io.File;
import java.io.IOException;

import org.apache.maven.artifact.Artifact;
import org.apache.maven.artifact.DependencyResolutionRequiredException;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.project.MavenProject;
import org.apache.maven.project.MavenProjectHelper;
import org.codehaus.plexus.archiver.ArchiverException;
import org.codehaus.plexus.archiver.jar.ManifestException;
import org.codehaus.plexus.archiver.zip.ZipArchiver;
import org.codehaus.plexus.util.DirectoryScanner;

/**
 * Zips up the Populate directory.
 * @goal package
 * @phase package
 * 
 */
public class PackageMojo extends AbstractMojo {

    /**
     * The maven project.
     *
     * @parameter expression="${project}"
     * @required
     * @readonly
     */
    private MavenProject project;

    /**
     * The directory where the CSE importfile is placed.
     * 
     * @parameter expression="${project.build.directory}"
     * @required
     */

    private File outputDirectory;

    /**
     * The name of the generated import file.
     *
     * @parameter expression="${project.build.finalName}"
     * @required
     */
    private String zipName;

    /**
     * The Zip archiver.
     * @parameter expression="${component.org.codehaus.plexus.archiver.Archiver#zip}"
     */
    private ZipArchiver zipArchiver;

    /**
     * Whether this is the main artifact being built. Set to <code>true</code> if you want to install or
     * deploy it to the local repository instead of the default one in an execution.
     *
     * @parameter expression="${primaryArtifact}" default-value="false"
     */
    private boolean primaryArtifact;

    /**
     * Single directory that contains the catalog files.
     *
     * @parameter expression="${basedir}/src/main/Populate"
     * @required
     */

    private File populateDirectory;

    /**
     * Classifier to add to the artifact generated. If given, the artifact will be an attachment instead.
     *
     * @parameter
     */
    private String classifier;

    /**
     * @component
     */
    private MavenProjectHelper projectHelper;

    protected static File getOutputFile(final File basedir,
            final String finalName, String classifier) {
        if (classifier == null) {
            classifier = "";
        } else if ((classifier.trim().length() > 0)
                && !classifier.startsWith("-")) {
            classifier = "-" + classifier;
        }

        return new File(basedir, finalName + classifier + ".zip");
    }

    public void execute() throws MojoExecutionException {
        try {
            final File targetFile = PackageMojo.getOutputFile(outputDirectory,
                    zipName, classifier);
            performPackaging(targetFile);
        } catch (final Exception e) {
            throw new MojoExecutionException("Could not zip", e);
        }
    }

    private void performPackaging(final File targetFile) throws IOException,
            ArchiverException, ManifestException,
            DependencyResolutionRequiredException, MojoExecutionException,
            MojoFailureException {

        //generate zip file
        getLog().info(
                "Generating CatalogMover import file "
                        + targetFile.getAbsolutePath());
        zipArchiver.setDestFile(targetFile);
        zipArchiver.addDirectory(populateDirectory, getIncludes(),
                getExcludes());
        zipArchiver.createArchive();

        final String classifier = this.classifier;
        if (classifier != null) {
            projectHelper.attachArtifact(getProject(), "zip", classifier,
                    targetFile);
        } else {
            final Artifact artifact = getProject().getArtifact();
            if (primaryArtifact) {
                artifact.setFile(targetFile);
            } else if ((artifact.getFile() == null)
                    || artifact.getFile().isDirectory()) {
                artifact.setFile(targetFile);
            }
        }
    }

    /**
     * @return the project
     */
    public MavenProject getProject() {
        return project;
    }

    /**
     * @param project the project to set
     */
    public void setProject(final MavenProject project) {
        this.project = project;
    }



    private String[] getIncludes() {
        return new String[] { "**" };

    }

    private String[] getExcludes() {
        return DirectoryScanner.DEFAULTEXCLUDES;

    }

}
