#!/usr/bin/perl
#
# collects a file from each of the servers of a cssh-cluster and 
# renames the local copy accordingly
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
                'clusters|l=s'           => \$serverlist,
                'set|s=s'                => \$serverset,
                'rename|r'               => \$rename,
                'help|h'                 => \$needshelp,
);

if ($needshelp) {
pod2usage(1);
}

die "Usage: $0 <remote-path> <local-path>\n" unless($ARGV[1]);

$remotepath = $ARGV[0];
$localpath = $ARGV[1];

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
        #print("$host\n");
    }
}

foreach $host (@hosts) {
    if ($host ne @hosts[0]) {
        chomp $host;
        if ($containsat) {
            $host=~s/root\@//; 
        }
        if ($rename) {
            ($dir, $file) = $remotepath =~ m/(.*\/)(.*)$/;
            $localfile = "/$file-$host";
        }
        system("scp -r root\@$host:$remotepath $localpath$localfile")
    }
}


__END__

=head1 NAME

collectscp - collects files by scp from Servers from /etc/clusters

=head1 SYNOPSIS

collectscp [options] <remote-path>  <local-path> 

 Options:
   --help help message
   --clusters specify clusters file
   --set specify set of servers to use
   --rename append servername to local files

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--clusters>

Specify an /etc/clusters-style list with servers to use.

=item B<--set>

Specify a set of servers in a serverlist to use.

=item B<--rename>

Renames local file/directory by appending the hostname. This is useful
if the filenames are all the same on each server. 

=back

=head1 DESCRIPTION

B<This program> will collect files by scp from a specified set of servers.
It takes a file or directory as argument, and a path from which it will copy
this file from each server to a local directory. 

=cut
