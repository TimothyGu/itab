package Tab::Tourn;
use base 'Tab::DBI';
Tab::Tourn->table('tourn');
Tab::Tourn->columns(Primary => qw/id/);
Tab::Tourn->columns(Essential => qw/name start end approved webname reg_start reg_end tz location hidden timestamp/);

Tab::Tourn->has_many(files => 'Tab::File', 'tourn');
Tab::Tourn->has_many(events => 'Tab::Event', 'tourn');
Tab::Tourn->has_many(emails => 'Tab::Email', 'tourn');
Tab::Tourn->has_many(judges => 'Tab::Judge', 'tourn');
Tab::Tourn->has_many(entries => 'Tab::Entry', 'tourn');
Tab::Tourn->has_many(ratings => 'Tab::Rating', 'tourn');
Tab::Tourn->has_many(strikes => 'Tab::Strike', 'tourn');
Tab::Tourn->has_many(schools => 'Tab::School', 'tourn');
Tab::Tourn->has_many(admins => 'Tab::TournAdmin', 'tourn');
Tab::Tourn->has_many(groups => 'Tab::JudgeGroup', 'tourn');
Tab::Tourn->has_many(timeslots => 'Tab::Timeslot', 'tourn');
Tab::Tourn->has_many(tourn_fees => 'Tab::TournFee', 'tourn');
Tab::Tourn->has_many(settings => 'Tab::TournSetting', 'tourn');
Tab::Tourn->has_many(tourn_sites => 'Tab::TournSite', 'tourn');
Tab::Tourn->has_many(concessions => 'Tab::Concession', 'tourn');
Tab::Tourn->has_many(rating_tiers => 'Tab::RatingTier', 'tourn');
Tab::Tourn->has_many(room_strikes => 'Tab::RoomStrike', 'tourn');
Tab::Tourn->has_many(school_fines => 'Tab::SchoolFine', 'tourn');
Tab::Tourn->has_many(housing_slots => 'Tab::HousingSlot', 'tourn');
Tab::Tourn->has_many(follow_tourns => 'Tab::FollowTourn', 'tourn');
Tab::Tourn->has_many(tourn_changes => 'Tab::TournChange', 'tourn');
Tab::Tourn->has_many(tourn_circuits => 'Tab::TournCircuit', 'tourn');
Tab::Tourn->has_many(event_doubles => 'Tab::EventDouble', 'tourn');
Tab::Tourn->has_many(tiebreak_sets => 'Tab::TiebreakSet', 'tourn');
Tab::Tourn->has_many(housing_students => 'Tab::HousingStudent', 'tourn');

__PACKAGE__->_register_datetimes( qw/start/);
__PACKAGE__->_register_datetimes( qw/end/);
__PACKAGE__->_register_datetimes( qw/reg_start/);
__PACKAGE__->_register_datetimes( qw/reg_end/);


Tab::Circuit->set_sql( by_tourn => "select distinct circuit.*
									from circuit, tourn_circuit
									where circuit.id = tourn_circuit.circuit
									and tourn_circuit.tourn = ?
									order by circuit.name");

sub circuits { 
	my $self = shift;
	return Tab::Circuit->search_by_tourn($self->id);
}

sub setting {

	my ($self, $tag, $value, $blob) = @_;

	my @existing = Tab::TournSetting->search(  
		tourn => $self->id,
		tag => $tag
	);

	if ($value && $value ne 0) { 

		if (@existing) {

			my $exists = shift @existing;
			$exists->value($value);
			$exists->text($blob) if $value eq "text";
			$exists->date($blob) if $value eq "date";
			$exists->update;

			foreach my $other (@existing) { 
				$other->delete;
			}

			return;

		} else {

			if ($value eq "text") { 
				my $setting = Tab::TournSetting->create({
					tourn => $self->id,
					tag => $tag,
					value => $value,
					value_text => $blob
	 			});
		 	} elsif ($value eq "date") {
				my $setting = Tab::TournSetting->create({
					tourn => $self->id,
					tag => $tag,
					value => $value,
					value_date => $blob
	 			});
			} else { 
				my $setting = Tab::TournSetting->create({
					tourn => $self->id,
					tag => $tag,
					value => $value
				});
			}

		}

	} else {

		return unless @existing;
		my $setting = shift @existing;
		return $setting->value_text if $setting->value eq "text";
		return $setting->value_date if $setting->value eq "date";
		return $setting->value;

	}

}

