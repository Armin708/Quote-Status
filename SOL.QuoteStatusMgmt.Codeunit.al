codeunit 50120 "Quote Status Mgmt"
{
    procedure CloseQuote(SalesQuote: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
    begin

        // In the CloseQuote procedure you need to write code to archive a Sales Quote.
        SalesSetup.Get();
        case SalesSetup."Archive Quotes" of
            SalesSetup."Archive Quotes"::Always:
                ArchiveManagement.ArchSalesDocumentNoConfirm(SalesQuote);
            SalesSetup."Archive Quotes"::Question:
                ArchiveManagement.ArchiveSalesDocument(SalesQuote);
        end;



    end;

}
