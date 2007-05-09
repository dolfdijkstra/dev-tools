package com.fatwire.cs.catalogmover.mover;

public class NullProgressMonitor implements IProgressMonitor {

    public void beginTask(String string, int i) {

    }

    public boolean isCanceled() {
        return false;
    }

    public void subTask(String string) {

    }

    public void worked(int i) {

    }

}
