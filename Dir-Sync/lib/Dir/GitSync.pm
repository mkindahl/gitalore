package Dir::GitSync;

our $VERSION = 0.01;

use Git;

use Net::Domain qw(hostname);
use Text::Wrap  qw(wrap);
use File::Basename;

use base 'Git';

sub generate_message {
    my ($self) = @_;
    my %files;

    for my $line ( $self->command( 'status', '--porcelain' ) ) {
        my ( $cat, $file ) = split( ' ', $line, 2 );
        push( @{ $files{$cat} }, $file );
    }

    my @message;
    push @message, wrap( "Added: ", "    ", @{ $files{'A'} }, "\n" )
      if exists $files{'A'};
    push @message, wrap( "Modified: ", "    ", @{ $files{'M'} }, "\n" )
      if exists $files{'M'};
    push @message, wrap( "Deleted: ", "    ", @{ $files{'D'} }, "\n" )
      if exists $files{'D'};
    for my $rename ( @{ $files{'R'} } ) {
        push @message, "Renamed: $rename\n";
    }

    return join( '', @message );
}

sub fetch {
    my ($repo) = @_;
    $repo->command( 'pull', '--quiet' );
}

sub store {
    my ($repo) = @_;
    $repo->command( 'pull', '--quiet', '--rebase', '-Xours' );
    $repo->command( 'push', '--quiet' );

}

sub try_create_commit {
    my ($repo) = @_;
    $repo->command( 'add', '-A' );

    # Generate a message and if it was non-empty, some files where added.
    my $message = $repo->generate_message();
    if ($message) {
        my $local =
          basename( $repo->command( 'rev-parse', '--show-toplevel' ) );
        my $hostname = hostname();
        $repo->command( 'commit', "-mCommit $local on $hostname",
            "-m$message" );
        return 1;
    }
    else {
        return 0;
    }
}

1;
__END__

=head1 NAME

mk-sync-dir <repository>

=head1 DESCRIPTION

Syncronize a directory using git(1) by:

1. Create a commit with all new, modified, renamed, and deleted files.

2. Pull and rebase the branch on the remote repository.

3. Push the resulting branch to the remote repository.

=head1 AUTHOR

Mats Kindahl <mats@kindahl.net>

=head1 LICENSE

Apache License 2.0
