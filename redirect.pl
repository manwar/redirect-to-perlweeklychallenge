#!/usr/bin/perl

use strict;
use warnings;

use File::Find qw(find);
use File::Path qw(make_path);

my $path = "../theweeklychallenge/docs";
my $old  = "docs/";

sub wanted {
    return if m{/css};
    return if m{/images};
    return if m{/plugins};
    return unless (/html$/ or -d $_);
    print "$_\n";

    if (-d $_) {
        print substr($_, length($path)), "\n";
        my $new_path = $old . substr($_, length($path));
        make_path($new_path);

        open (my $f, ">", $new_path . "/index.html");
        print $f template(substr($_, length($path)));
        close ($f);

    }

}

find({ wanted => \&wanted, no_chdir => 1 }, $path);

sub template {
    my ($path) = @_;

    return qq {
<!DOCTYPE html>
<meta charset="utf-8">
<title>Redirecting to https://theweeklychallenge.org$path</title>
<meta http-equiv="refresh" content="0; URL=https://theweeklychallenge.org$path">
<link rel="canonical" href="https://theweeklychallenge.org$path">
};

}
