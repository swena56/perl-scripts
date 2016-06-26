 package AbstractInterestCalculator;

  use Class::Interface;
  &abstract;   # this actually declares this class to be abstract;

  use Class::AccessorMaker {
    interest => 5.1,
    maxInterestValue => 0,
  }

  # a hook for doing calculations
  sub calculate {
    my ( $self, $value ) = @_

    $self->prepare();
    $value += $self->getInterestValue( $value );

    return $value;
  }

  sub prepare;          # prepare calculations
  sub getInterstValue;  # get the interest value

  1;