package Tab::Circuit;
use base 'Tab::DBI';
Tab::Circuit->table('circuit');
Tab::Circuit->columns(Primary => qw/id/);
Tab::Circuit->columns(Essential => qw/name abbr tz active state country webname/);
Tab::Circuit->columns(Others => qw/timestamp/);

Tab::Circuit->has_many(sites => "Tab::Site");
Tab::Circuit->has_many(regions => "Tab::Region");

Tab::Circuit->has_many(webpages => "Tab::Webpage");
Tab::Circuit->has_many(tourn_circuits => "Tab::TournCircuit");
Tab::Circuit->has_many(circuit_admins => "Tab::CircuitAdmin");
Tab::Circuit->has_many(chapter_circuits => "Tab::ChapterCircuit");
Tab::Circuit->has_many(settings => "Tab::CircuitSetting", "circuit");
Tab::Circuit->has_many(circuit_memberships => "Tab::CircuitMembership");
Tab::Circuit->has_many(tourns => [ Tab::TournCircuit => 'tourn' ]);
Tab::Circuit->has_many(admins => [ Tab::CircuitAdmin => 'account' ]);

__PACKAGE__->_register_datetimes( qw/timestamp/);

sub location { 
	my $self = shift;
	my $location = $self->state."/" if $self->state;
	return $location.$self->country;
}

Tab::Account->set_sql(by_circuit => "select distinct account.* 
							from account, circuit_admin
							where account.id = circuit_admin.account
							and circuit_admin.circuit = ?
							order by account.last");

sub shorter_name {
	my $self = shift;
	my $name = $self->name;
	$name =~ s/Catholic Forensic Circuit/CFL/;
	$name =~ s/Catholic Forensics Circuit/CFL/;
	$name =~ s/Forensic Circuit/FL/;
	$name =~ s/Forensics Circuit/FL/;
	$name =~ s/Forensic Association/FA/;
	$name =~ s/Forensics Association/FA/;
	$name =~ s/Urban Debate Circuit/UDL/;
	$name =~ s/High School Speech Circuit/HSSL/;
	$name =~ s/High School Debate Circuit/HSDL/;
	$name =~ s/Debate Circuit/DL/;
	return $name;
}


sub setting {

	my ($self, $tag, $value, $blob) = @_;

	my @existing = Tab::CircuitSetting->search(  
		circuit => $self->id,
		tag => $tag
	);

    if (defined $value) { 

		if (@existing) {

			my $exists = shift @existing;
			$exists->value($value);
			$exists->value_text($blob) if $value eq "text";
			$exists->value_date($blob) if $value eq "date";
			$exists->update;
		
			if ($value eq "delete" || $value eq "" || $value eq "0") { 
				$exists->delete;
			}

			foreach my $other (@existing) { 
				$other->delete;
			}

			return;

		} elsif ($value ne "delete" && $value && $value ne "0") {

			my $exists = Tab::CircuitSetting->create({
				circuit => $self->id,
				tag => $tag,
				value => $value,
			});

			if ($value eq "text") { 
				$exists->value_text($blob);
			}

			if ($value eq "date") { 
				$exists->value_date($blob);
			}

			$exists->update;

		}

	} else {

		return unless @existing;

		my $setting = shift @existing;

		foreach my $other (@existing) { 
			$other->delete;
		}

		return $setting->value_text if $setting->value eq "text";
		return $setting->value_date if $setting->value eq "date";
		return $setting->value;

	}

}