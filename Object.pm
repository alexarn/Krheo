package Krheo::Object;
use strict;
use warnings;

sub new {
    my ($class, $type ) = @_;

    my $this = {
	type => $type,
	attr => [],
    };
    return bless $this, $class;
}

sub dmp {
    my $this = shift;

    my $type = $this->{type};
    my $to_dump = "define $type" . "{\n";
    foreach ( @{ $this->{attr} } ) {
	my $key = $_->{key};
	my $val = $_->{val};
	my $comment = $this->{comment};

	$to_dump .= "    $key    $val";  
	$to_dump .= " ; $comment" if $comment;  
	$to_dump .= "\n";
    }
    $to_dump .= "    }\n\n";
    return $to_dump;
}
1;
