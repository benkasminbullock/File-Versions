#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use Perl::Build qw/get_info get_commit/;
use Perl::Build::Pod ':all';
use Deploy qw/do_system older/;
use Getopt::Long;
my $ok = GetOptions (
    'force' => \my $force,
    'verbose' => \my $verbose,
);
if (! $ok) {
    usage ();
    exit;
}
my %pbv = (
    base => $Bin,
    verbose => $verbose,
);
my $info = get_info (%pbv);
my $commit = get_commit (%pbv);

# Names of the input and output files containing the documentation.

my $pm = $info->{pm};
my $pod = $pm;
$pod =~ s/\.pm$/.pod/;
my $input = "$Bin/$pod.tmpl";
my $output = "$Bin/$pod";

# Template toolkit variable holder

my %vars = (
    info => $info,
    commit => $commit,
);

my $tt = Template->new (
    ABSOLUTE => 1,
    INCLUDE_PATH => [
	$Bin,
	pbtmpl (),
	"$Bin/examples",
    ],
    ENCODING => 'UTF8',
    FILTERS => {
        xtidy => [
            \& xtidy,
            0,
        ],
    },
    STRICT => 1,
);

# Make an example file
do_system ("cd examples;purge;touch 'file'");
my @examples = <$Bin/examples/*.pl>;
for my $example (@examples) {
    my $output = $example;
    $output =~ s/\.pl$/-out.txt/;
    if (older ($output, $example) || $force) {
	do_system ("perl -I$Bin/lib -I$Bin/blib/lib -I$Bin/blib/arch $example > $output 2>&1", $verbose);
    }
}

chmod 0644, $output;
$tt->process ($input, \%vars, $output, binmode => 'utf8')
    or die '' . $tt->error ();
chmod 0444, $output;

exit;

sub usage
{
    print <<USAGEEOF;
--verbose
--force
USAGEEOF
}

