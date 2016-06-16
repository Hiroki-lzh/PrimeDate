#!/usr/bin/perl
#------------------------------------
# Author        : Hiroki.lzh
# Descripsion   : Output PrimeDate of the year
#------------------------------------

#---------------------------
#  [Module] Using Modules
#---------------------------
use strict;
use warnings;
use Getopt::Long;
use Time::Local;

#---------------------------
#  [Config] System Config
#---------------------------
my $version     ="1";
my $revision    ="0";
my $revdate     ="2015/06/04";
my $sysname     ="PrimeDate";

#---------------------------
#  [Func] SetOption
#       Return
#               NUM = Normal Exec, Output -y YEAR or this year.
#       Exit
#               0 = Normal Exit
#---------------------------
sub SetOption() {
	my %opts = ();
	GetOptions(\%opts, 'version', 'help', 'year=i');

	if( defined $opts{version} == 1) {
		printf("%s ver.%s.%s (created %s)\n", $sysname, $version, $revision, $revdate);
		exit 0;
	} elsif ( defined $opts{help} == 1) {
		print	"Usage: $0 [-hv] [-y] YEAR \n\n".
			"Options:\n".
			"  -h --help \t Give this help.\n".
			"  -v --version \t Display version number.\n".
			"  -y num or --year num \t Set Year to investigate.\n";
		exit 0;
	} elsif ( defined $opts{year} == 1) {
		return $opts{year};
	} else {
		(my $sec, my $min,my $hour,my $mday, my $mon, my $year) = localtime(time);
		$year += 1900;
		return $year;
	}
}

#---------------------------
#  [Func] GetLastDay
#	Input
#		$1 = Year
#		$2 = Number of Month
#	Return
#		NUM = Last day of the month
#		-1  = Error
#---------------------------
sub GetLastDay {
	my($year, $mon) = @_;
	if(!$year || !$mon) {return -1;}
	#if($year < 1900 || $year > 2023) {return -1;}
	if($mon < 1 || $mon > 12) {return -1;}
	if($mon == 12) {$mon = 0;}
	my $time = timelocal(0, 0, 0, 1, $mon, $year-1900);
	$time -= 60*60*24;
	my @date = localtime($time);
	return $date[3];
}

#---------------------------
#  [Func] PrimeNumbers
#	Input
#		$_[0] = YEAR
#       Return
#               @prime_numbers = Prime List
#---------------------------
sub PrimeNumbers {
	my $chk = $_[0];
	my @numbers = (2..$chk);
	my @prime_numbers;
	my $chksqrt = sqrt $chk;
	while(1){
		if($numbers[0] > $chksqrt){
			push @prime_numbers, @numbers;
			last;
		}
		my $number = shift @numbers;
		#print "DEBUG :: $number / $chksqrt \n";
		push @prime_numbers, $number;
		@numbers = grep { $_ % $number != 0 } @numbers;
	}

	return @prime_numbers;
}

#---------------------------
#  [Main] Main Programs
#---------------------------

# OptionCheck
my $year = &SetOption();

print "=================\n";
print "YEAR: $year\n";
# Get Target Days
print "=================\n";
print "TargetList:\n";
my @targets;
for (my $month = 1; $month < 13; $month++){
	my $lastday = &GetLastDay($year,$month);
	for (my $day = 1; $day < $lastday+1 ; $day++){
		my $setday = sprintf("%04d%02d%02d",$year,$month,$day);
		push(@targets,$setday);
		print "$setday\n";
	}
}

# Check Prime Number of Year
print "=================\n";
print "Prime Numbers of $year:\n";

## Get the last day of the year 's data
my @numbers = &PrimeNumbers($targets[$#targets]);

foreach my $cnt (@targets) {
	if (grep {$_ == $cnt} @numbers ){
		print " ----> $cnt is Prime Date!\n"; 
	} else {
		#print "$cnt is not prime... \n";
	}
}

