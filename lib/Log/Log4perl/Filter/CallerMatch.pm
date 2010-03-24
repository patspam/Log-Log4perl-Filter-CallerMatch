package Log::Log4perl::Filter::CallerMatch;

# ABSTRACT:  Filter Log4perl messages based on call frames

use 5.006;
use strict;
use Log::Log4perl::Config;
use base 'Log::Log4perl::Filter';
use Carp;

=method new

Constructor. Refer to L<Log::Log4perl::Filter> for more information

=cut

sub new {
    my ( $class, %options ) = @_;

    my $self = {
        AcceptOnMatch => 1,
        MinCallFrame  => 0,
        MaxCallFrame  => 5,
        %options,
    };

    $self->{AcceptOnMatch}  = Log::Log4perl::Config::boolean_to_perlish( $self->{AcceptOnMatch} );
    $self->{SubToMatch}     = defined $self->{SubToMatch} ? qr($self->{SubToMatch}) : qr/.*/;
    $self->{PackageToMatch} = defined $self->{PackageToMatch} ? qr($self->{PackageToMatch}) : qr/.*/;
    $self->{StringToMatch}  = defined $self->{StringToMatch} ? qr($self->{StringToMatch}) : qr/.*/;

    if ( defined $self->{CallFrame} ) {
        $self->{MinCallFrame} = $self->{MaxCallFrame} = $self->{CallFrame};
    }

    bless $self, $class;

    return $self;
}

=method ok

Decides whether log message should be accepted or not. Refer to L<Log::Log4perl::Filter> for more information

=cut

sub ok {
    my ( $self, %p ) = @_;

    my $message = join $Log::Log4perl::JOIN_MSG_ARRAY_CHAR, @{ $p{message} };

    my ( $s_regex, $p_regex, $m_regex ) = ( $self->{SubToMatch}, $self->{PackageToMatch}, $self->{StringToMatch} );
    
    foreach my $i ( $self->{MinCallFrame} .. $self->{MaxCallFrame} ) {
        my ( $package, $sub ) = ( caller $i )[ 0, 3 ];
        no warnings;
        if ( $sub =~ $s_regex && $package =~ $p_regex && $message =~ $m_regex ) {
            return $self->{AcceptOnMatch};
        }
    }
    return !$self->{AcceptOnMatch};
}

1;
__END__

=head1 DESCRIPTION

This Log4perl custom filter checks the call stack using caller() and filters
the subroutine and package using user-provided regular expressions. You can specify
a specific call frame to test against, or have the filter iterate through a range of call frames.

=head1 SYNOPSIS

 log4perl.logger = ALL, A1
 log4perl.appender.A1        = Log::Log4perl::Appender::TestBuffer
 log4perl.appender.A1.Filter = MyFilter
 log4perl.appender.A1.layout = Log::Log4perl::Layout::SimpleLayout
    
 log4perl.filter.MyFilter                = Log::Log4perl::Filter::CallerMatch
 log4perl.filter.MyFilter.SubToMatch     = WebGUI::Session::ErrorHandler
 log4perl.filter.MyFilter.PackageToMatch = Flux::
 log4perl.filter.MyFilter.StringToMatch  = Operand1
 
=attr StringToMatch

A perl5 regular expression, matched against the log message.

=attr AcceptOnMatch

Defines if the filter is supposed to pass or block the message on a match (C<true> or C<false>).

=attr PackageToMatch

A perl5 regular expression, matched against the 1st item in the array returned by caller() (e.g. "package")

=attr SubToMatch

A perl5 regular expression, matched against the 4th item in the array returned by caller() (e.g. "subroutine")

=attr CallFrame

The call frame to use when requesting information from caller(). (e.g. $i in caller($i)

=attr MinCallFrame

The first call frame tested against when iterating through a series of call frames. Ignored if CallFrame specified.

=attr MaxCallFrame

The last call frame tested against when iterating through a series of call frames. Ignored if CallFrame specified.

=head1 SEE ALSO

L<Log::Log4perl::Filter>,
L<Log::Log4perl::Filter::StringMatch>,
L<Log::Log4perl::Filter::LevelMatch>,
L<Log::Log4perl::Filter::LevelRange>,
L<Log::Log4perl::Filter::Boolean>

=cut

1;
