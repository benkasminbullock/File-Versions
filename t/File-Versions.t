use warnings;
use strict;
use Test::More tests => 11;
use FindBin;
use autodie;
use Cwd;
BEGIN { use_ok('File::Versions') };
use File::Versions;

use File::Versions qw/make_backup backup_name/;

my $start_dir = getcwd;
my $tempdir = "$FindBin::Bin/temp";
if (-d $tempdir) {
    system ("rm -rf $tempdir");
}
mkdir $tempdir;
chdir $tempdir;

# Test that the backup name is the same as the given name when the
# file does not exist.

my $file1 = 'file';
my $backup1_1 = backup_name ($file1);
ok ($backup1_1 eq $file1);

# Test the numbered version control.

system ("touch $file1");
$ENV{VERSION_CONTROL} = 'numbered';
my $backup1_2 = backup_name ($file1);
ok ($backup1_2 eq "$file1\.~1~");
my $backup1_3 = make_backup ($file1);
ok ($backup1_3 eq "$file1\.~1~");
ok (-f $backup1_3);
system ("touch $file1");
my $backup1_4 = make_backup ($file1);
ok ($backup1_4 eq "$file1\.~2~");
ok (-f $backup1_4);
ok (-f $backup1_3);

unlink $file1, $backup1_1, $backup1_2, $backup1_3, $backup1_4;

# Test the simple backup part.

$ENV{VERSION_CONTROL} = 'simple';
$ENV{SIMPLE_BACKUP_SUFFIX} = undef;
my $file2 = 'file2';
system ("touch $file2");
my $backup2_1 = backup_name ($file2);
ok ($backup2_1 eq 'file2~');
my $backup2_2 = make_backup ($file2);
ok ($backup2_2 eq 'file2~');
ok (-f $backup2_2);

unlink $file2, $backup2_1, $backup2_2;

chdir $start_dir;
rmdir $tempdir;

# Local variables:
# mode: perl
# End:
