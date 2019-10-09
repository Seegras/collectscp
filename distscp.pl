#!/usr/bin/perl
#
# distributes a file onto one place on all servers of cssh-clusters.
# 
# Author:   Peter Keel <seegras@discordia.ch>
# Date:     ?
# Revision: 2008-07-01
# Version:  0.1
# License:  Artistic License 2.0 or MIT License or GPLv2 
# URL:      http://seegras.discordia.ch/Programs/
#


use Getopt::Long;
use Pod::Usage;

# Default Config
$serverlist = '~/.clusterssh/clusters';
$serverset = 'all';

&Getopt::Long::Configure( 'pass_through', 'no_autoabbrev');
&Getopt::Long::GetOptions(
                'clusters|l=s'          => \$serverlist,
                'set|s=s'               => \$serverset,
                'help|h'                => \$needshelp,
);

if ($needshelp) {
pod2usage(1);
}

die "Usage: $0 <local-path> <remote-path>\n" unless($ARGV[1]);

$localfile = $ARGV[0];
$remotepath = $ARGV[1];

open(IN_FILE,"<$serverlist") || die "Cannot open $serverlist for input\n";
while(<IN_FILE>){
    @content = split(/ /);
    if ($content[0] eq $serverset) {
        @hosts = @content;
    }
    if ($content[1]=~m/\@/) {
        $containsat = 1; 
    } 
}
close IN;

if (! @hosts) {
die "Set of Servers $serverset not found.\n"; 
}

foreach $host (@hosts) {
    if ($host ne @hosts[0]) {
        chomp $host;
        if ($containsat) {
            $host=~s/root\@//; 
        }
        system("scp -r $localfile root\@$host:$remotepath")
    }
}

__END__

=head1 NAME

distscp - Distributes files by scp to Servers from /etc/clusters

=head1 SYNOPSIS

distscp [options] <file ...> <remote-path>

 Options:
   --help help message
   --clusters specify clusters file
   --set specify set of servers to use

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--clusters>

Specify an /etc/clusters-style list with servers to use.

=item B<--set>

Specify a set of servers in a serverlist to use.

=back

=head1 DESCRIPTION

B<This program> will distribute files by scp to a specified set of servers.
It takes a file or directory as argument, and a path to which it will copy
this file onto each server. 

=cut
