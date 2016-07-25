# --
# Copyright (C) 2016 Perl-Services.de, http://www.perl-services.de/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::FilterContent::MoveAttachmentColumn;

use strict;
use warnings;

use List::Util qw(first);

our @ObjectDependencies = qw(
    Kernel::Config
    Kernel::System::Log
    Kernel::System::Main
    Kernel::System::DB
    Kernel::System::Web::Request
    Kernel::Output::HTML::Layout
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{UserID} = $Param{UserID};

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get template name
    my $Templatename = $ParamObject->GetParam( Param => 'Action' );
    return 1 if !$Templatename;
    return 1 if !$Param{Templates}->{$Templatename};

    my $After = ( $Param{Position} // 3 ) - 2;

    ${ $Param{Data} } =~ s~</body>~
        <script type="text/javascript">//<![CDATA[
            Core.App.Ready(function () {
                \$('#ArticleTable thead tr').each( function() {
                    var row = \$(this);
                    row.children(":eq($After)").after(
                        row.children(":eq(7)")
                    );
                });
                \$('#ArticleTable tbody tr').each( function() {
                    var row = \$(this);
                    row.children(":eq($After)").after(
                        row.children(":eq(7)")
                    );
                });
            });
        //]]></script></body>
    ~;

    return 1;
}

1;
