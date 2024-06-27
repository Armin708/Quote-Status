pageextension 50124 "SOL Business Manager RC Ext" extends "Business Manager Role Center"
{
    layout
    {
        addbefore("Favorite Accounts")
        {
            part(SOLShowQuotesWon; "SOL Show Quotes")
            {
                ApplicationArea = Basic, Suite;
                SubPageView = where("Won/Lost Quote Status" = const("Won"));
            }
        }

        addbefore("Favorite Accounts")
        {
            part(SOLShowQuotesLost; "SOL Show Quotes")
            {
                ApplicationArea = Basic, Suite;
                SubPageView = where("Won/Lost Quote Status" = const("Lost"));
            }
        }
    }
}
