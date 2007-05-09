package com.fatwire.cs.catalogmover.catalogs;

import static com.fatwire.cs.catalogmover.catalogs.TableData.COLTYPEBINARY;
import static com.fatwire.cs.catalogmover.catalogs.TableData.COLTYPEDATE;
import static com.fatwire.cs.catalogmover.catalogs.TableData.COLTYPENUMBER;
import static com.fatwire.cs.catalogmover.catalogs.TableData.COLTYPETEXT;
import static com.fatwire.cs.catalogmover.catalogs.TableData.COLTYPEUNKNOWN;
import static com.fatwire.cs.catalogmover.catalogs.TableData.HTMLTABLEVERSION;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

public class TableExporter {
    public static final String falsestr = "false";

    public static final String truestr = "true";

    public static final String brk = "<br>\n";

    public static final String foreign = "fgn";

    public static final String text = "(text)";

    public static final String number = "(integer)";

    public static final String doublestr = "(double)";

    public static final String datetime = "(date/time)";

    public static final String binarydata = "(binary)";

    public static final String unknown = "Unknown argument:";

    final private TableData tableData;

    public TableExporter(final TableData tableData) {
        super();
        this.tableData = tableData;
    }

    /**
     * Export to HTML
     * 
     * @param SelectedRows
     *            vector of row indicess to include or specify null for all rows
     */
    public StringBuffer exportHTML(int[] SelectedRows, String sDBType,
            boolean bRowSummary) {
        StringWriter oStringWriter = new StringWriter();
        PrintWriter oPrintWriter = new PrintWriter(oStringWriter);

        try {

            // this entry writes the page wrapping stuff,
            // the one that writes to a stream has that
            // already
            oPrintWriter.print(HTML.startpage(HTML.gencomment()));
            exportHTML(SelectedRows, sDBType, bRowSummary, oPrintWriter);
            oPrintWriter.print(HTML.endpage());
            oPrintWriter.flush();
            return new StringBuffer(oStringWriter.toString());
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Export to HTML
     * 
     * @param selectedRows
     *            vector of row indicess to include or specify null for all rows
     */
    public void exportHTML(int[] selectedRows, String dbType,
            boolean rowSummary, PrintWriter printWriter) throws IOException {
        String type;
        //
        // Create an identifier based on the table name
        //
        String wrapperUniqueID = Long.toString(tableData.getTableName()
                .hashCode() & 0xFFFF);
        printWriter.println();
        printWriter.print(brk);

        // ---
        // Set the version id of the table format
        printWriter.print(TableParser.m_sStartTableVersionTag);
        printWriter.print(HTMLTABLEVERSION);
        printWriter.print(TableParser.m_sEndTableVersionTag);
        printWriter.println();

        // Set the unique data wrapper value
        printWriter.print(TableParser.m_sWrapperStartTag);
        printWriter.print(TableParser.m_sWRAPID);
        printWriter.print(wrapperUniqueID);
        printWriter.print(TableParser.m_sWrapperEndTag);
        printWriter.println();
        String wrapperStart = TableParser.m_sWRAPID + wrapperUniqueID
                + TableParser.m_sStartID;
        String wrapperEnd = TableParser.m_sWRAPID + wrapperUniqueID
                + TableParser.m_sEndID;

        printWriter.println(HTML.comment(getTableName()));
        printWriter.print(HTML.table(1, 0, 2));
        printWriter.print(HTML.caption(getTableName()));
        printWriter.println();

        type = getTableType();
        if (type == null)
            type = foreign;
        printWriter.print(TableParser.m_sStartTableTypeTag);
        printWriter.print(type);
        printWriter.print(TableParser.m_sEndTableTypeTag);
        printWriter.println();

        if (isTracked()) {
            printWriter.print(TableParser.m_sStartTableTrackedTag);
            printWriter.print(truestr);
            printWriter.print(TableParser.m_sEndTableTrackedTag);
            printWriter.println();
        }

        printWriter.print(TableParser.m_sStartDBTypeTag);
        printWriter.print(dbType);
        printWriter.print(TableParser.m_sEndDBTypeTag);
        printWriter.println();

        printWriter.print("<tr>");

        int isz = getColumnCount();
        for (int i = 0; i < isz; i++) {
            switch (getType(i)) {
            case COLTYPETEXT:
                type = text;
                break;

            case COLTYPENUMBER:
                type = number;
                break;

            case COLTYPEDATE:
                type = datetime;
                break;

            case COLTYPEBINARY:
                type = binarydata;
                break;

            case COLTYPEUNKNOWN:
                type = unknown;
                break;

            default:
                type = null;
                break;
            }

            // table info
            String h = getHeader(i);
            h = HTML.underlinethis(HTML.boldthis(h));
            String s = getSchema(i);
            if (type != null)
                s += (";" + type);

            printWriter.print("\t");
            printWriter.print(HTML.header(h + HTML.comment(s)));
        }
        printWriter.println("</tr>");

        // either a set of rows or all rows
        // are to be exported based on input
        boolean bAll = (selectedRows == null);
        int sz = (bAll ? getRowCount() : selectedRows.length);
        int numColumns = getColumnCount();
        for (int i = 0; i < sz; i++) {
            // next row to take
            int k = (bAll ? i : selectedRows[i]);

            printWriter.println("<tr>");

            for (int colNum = 0; colNum < numColumns; colNum++) {
                printWriter.print("\t<td>");
                printWriter.print(wrapperStart);
                printWriter.print(getCell(k, colNum));
                printWriter.print(wrapperEnd);
                printWriter.println("</td>");
            }
            printWriter.println("</tr>");
        }
        printWriter.print(HTML.endtable());

        if (rowSummary) {
            printWriter.print(brk);
            printWriter.print(getRowCount());
            printWriter.println();
        }
    }

    private boolean isTracked() {
        return tableData.isTracked();
    }

    private int getRowCount() {
        return tableData.getRowCount();
    }

    private String getCell(int rowNum, int colNum) {
        return tableData.getCell(rowNum, colNum).getCell();
    }

    private String getSchema(int i) {
        return tableData.getHeaders().get(i).getSchema();
    }

    private String getHeader(int i) {
        return tableData.getHeaders().get(i).getHeader();
    }

    private int getType(int i) {
        return tableData.getHeaders().get(i).getType();
    }

    private int getColumnCount() {
        return tableData.getHeaders().size();
    }

    private String getTableType() {
        return tableData.getTableType();
    }

    private String getTableName() {
        return tableData.getTableName();
    }

}
