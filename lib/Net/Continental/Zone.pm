use strict;
use warnings;
no warnings 'once';
package Net::Continental::Zone;
# ABSTRACT: a zone of IP space
$Net::Continental::Zone::VERSION = '0.010';
use Locale::Codes::Country ();
use Net::Domain::TLD ();

# =method new
#
# B<Achtung!>  There is no C<new> method for you to use.  Instead, do this:
#
#   my $zone = Net::Continental->zone('au');
#
# =cut

sub _new { bless $_[1] => $_[0] }

# =method code
#
# This returns the zone's zone code.
#
# =method in_nerddk
#
# This is true if the nerd.dk country blacklist is capable, using its encoding
# scheme, of indicating a hit from this country.
#
# =method nerd_response
#
# This returns the response that will be given by the nerd.dk country blacklist
# for IPs in this zone, if one is defined.
#
# =method continent
#
# This returns the continent in which the zone has been placed.  These are
# subject to change, for now, and there may be a method by which to define your
# own classifications.  I do not want to get angry email from people in Georgia!
#
# =method description
#
# This is a short description of the zone, like "United States" or "Soviet
# Union."
#
# =method is_tld
#
# This returns true if the zone code is also a country code TLD.
#
# =cut

sub code          { $_[0][0] }

sub in_nerddk     {
  return defined $_[0]->nerd_response;
}

sub nerd_response {
  my ($self) = @_;

  my $n = Locale::Codes::Country::country_code2code(
    $self->code,
    'alpha-2',
    'numeric',
  );

  # coping with broken(?) Locale::Codes::Country -- rjbs, 2014-01-20
  $n = 158 if $self->code eq 'tw';

  return unless $n;
  my $top = $n >> 8;
  my $bot = $n % 256;
  return "127.0.$top.$bot";
}

sub continent     { $Net::Continental::Continent{ $_[0][1] } }
sub description   { $_[0][2] }
sub is_tld        { Net::Domain::TLD::tld_exists($_[0][0], 'cc'); }

sub tld           {
  return $_[0][3] if Net::Domain::TLD::tld_exists($_[0][3], 'cc');
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Net::Continental::Zone - a zone of IP space

=head1 VERSION

version 0.010

=head1 METHODS

=head2 new

B<Achtung!>  There is no C<new> method for you to use.  Instead, do this:

  my $zone = Net::Continental->zone('au');

=head2 code

This returns the zone's zone code.

=head2 in_nerddk

This is true if the nerd.dk country blacklist is capable, using its encoding
scheme, of indicating a hit from this country.

=head2 nerd_response

This returns the response that will be given by the nerd.dk country blacklist
for IPs in this zone, if one is defined.

=head2 continent

This returns the continent in which the zone has been placed.  These are
subject to change, for now, and there may be a method by which to define your
own classifications.  I do not want to get angry email from people in Georgia!

=head2 description

This is a short description of the zone, like "United States" or "Soviet
Union."

=head2 is_tld

This returns true if the zone code is also a country code TLD.

=head1 AUTHOR

Ricardo Signes <rjbs@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2009 by Ricardo Signes.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
