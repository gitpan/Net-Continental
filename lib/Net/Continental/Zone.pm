use strict;
use warnings;
no warnings 'once';
package Net::Continental::Zone;
{
  $Net::Continental::Zone::VERSION = '0.007';
}
# ABSTRACT: a zone of IP space

use Net::Domain::TLD ();


sub _new { bless $_[1] => $_[0] }


sub code          { $_[0][0] }
sub in_nerddk     { defined $Net::Continental::nerd_response{ $_[0][0] } }
sub nerd_response { $Net::Continental::nerd_response{ $_[0][0] } }
sub continent     { $Net::Continental::Continent{ $_[0][1] } }
sub description   { $_[0][2] }
sub is_tld        { Net::Domain::TLD::tld_exists($_[0][0], 'cc'); }

1;

__END__

=pod

=head1 NAME

Net::Continental::Zone - a zone of IP space

=head1 VERSION

version 0.007

=head1 METHODS

=head2 new

B<Achtung!>  There is no C<new> method for you to use.  Instead, do this:

  my $zone = Net::Continental->zone('au');

=head2 code

This returns the zone's zone code.

=head2 in_nerddk

This is true if the nerd.dk country blacklist has an entry for this zone.

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
