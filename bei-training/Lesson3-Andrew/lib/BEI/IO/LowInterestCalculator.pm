 package LowInterestCalculator;

  use Class::Interface;
  &extends( 'AbstractInterestCalculator' );

  sub prepare {
    my ( $self ) = @_;
    $self->interest(1.3);

    # we don't give interest if the value of the account is or
    # exceeds $10.000
    $self->maxInterestValue(10000)
  }

  sub getInterstValue {
    my ( $self, $value ) = @_;

    if ( $self->maxInterestValue && $value >= $self->maxInterestValue ) {
      return 0;
    }

    $value *= $self->interest;

    return $value;
  }