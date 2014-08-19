package Tab::TournCircuit;
use base 'Tab::DBI';
Tab::TournCircuit->table('tourn_circuit');
Tab::TournCircuit->columns(Primary => qw/id/);
Tab::TournCircuit->columns(Essential => qw/circuit tourn timestamp approved/) ;

Tab::TournCircuit->has_a(tourn => "Tab::Tourn");
Tab::TournCircuit->has_a(circuit => "Tab::Circuit");

__PACKAGE__->_register_datetimes( qw/timestamp/);

