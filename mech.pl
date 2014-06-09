use strict;
use warnings;
use Data::Dumper;
use WWW::Mechanize;
use Text::Unidecode qw(unidecode);
use HTML::Entities qw(decode_entities encode_entities);
use utf8;

my $mech = WWW::Mechanize->new;

$mech->agent_alias('Linux Mozilla');
$mech->get('http://apply.dataprocessors.com.au/');

my $form =  $mech->content; 
print Dumper $mech->current_form();
my $hex_str = parse_html($form);


my $value = decode_hex($hex_str);

print $value."\n";

$mech->submit_form(
  form_name => '',
  fields => {
    jobref => "PO32",
    value => $value,
  },
);

print $mech->content . "\n";


sub decode_hex {
	my ($str) = @_;
	#my $str ='&#x31;&#x38;&#xA0;*&#xA0;&#x37;&#x30;&#xA0;+&#xA0;&#x37;&#x30;';
	$str = unidecode(decode_entities($str));
	print $str . "\n";
	return eval ($str);
}

sub parse_html {
	my ($html) = @_;
	$html =~ s/\s//gi;
	#Bad HTML tags to we cant use xml parser so we use dodgy regex	
	$html =~ /\<p\>Question:(.+)\<\/p\</;
	return $1;
				
}
