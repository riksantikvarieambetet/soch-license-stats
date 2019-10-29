#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use 5.022;
use open qw(:utf8 :std);

use autodie qw(:file);
use LWP::UserAgent;
use Text::CSV;
use URI::Escape qw(uri_escape);
use XML::XPath;

# Enforce proper garbage collection on XML::XPath:
$XML::XPath::SafeMode = 1;

my $base = 'http://kulturarvsdata.se/ksamsok/api';

my $ua = LWP::UserAgent->new();
$ua->agent('SOCH-licenses 0.1');
$ua->default_header('Accept' => 'application/rdf+xml, application/xml, text/xml');
my $stats_path = '/result/term/indexFields/value/text()';
my $count_path = '/result/totalHits/text()';

open my $fh, '>', 'org-licenses.csv';
my $csv = Text::CSV->new({binary => 1});

# Query SOCH for a list of all service organisations providing data:
my $req = HTTP::Request->new(GET => join('', $base, '?method=statistic', '&index=serviceOrganization=*'));
my @providers = get_values($ua, $req, $stats_path);

# Query SOCH for a list of all licenses in use, plus the empty string:
$req = HTTP::Request->new(GET => join('', $base, '?method=statistic', '&index=mediaLicense=*'));
my @licenses = (get_values($ua, $req, $stats_path), '');
$csv->say($fh, ['Leverantör', 'Totala objekt', sort @licenses]);

for my $provider (sort @providers) {
	my $req = HTTP::Request->new(GET => join('', $base, '?method=search', '&hitsPerPage=1', '&startRecord=1', '&query=', uri_escape(join('', 'thumbnailExists=j AND serviceOrganization="')), $provider, '"'));
	my ($total) = get_values($ua, $req, $count_path);
	my @fields;
	push @fields, $provider, $total;
	for my $license (sort @licenses) {
		my $req = HTTP::Request->new(GET => join('', $base, '?method=search', '&hitsPerPage=1', '&startRecord=1', '&query=', uri_escape(join('', 'thumbnailExists=j AND serviceOrganization="')), $provider, uri_escape(join('', '" AND mediaLicense="', $license, '"'))));
		my ($instances) = get_values($ua, $req, $count_path);
		push @fields, $instances;
	}
	$csv->say($fh, \@fields);
}
close $fh;

# Fetch result for a given query:
sub get_values {
	my ($ua, $req, $path) = @_;
	$req->accept_decodable;
	my $response = $ua->request($req);
	unless ($response->is_success) {
		die 'Error executing query: ', $response->status_line, "\n";
	}
	my $xp = XML::XPath->new($response->decoded_content);
	my $values = $xp->find($path);
	my @values = map {XML::XPath::XMLParser::as_string($_)} $values->get_nodelist();
	$xp->cleanup();
	return @values;
}
