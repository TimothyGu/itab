package Tab::Judge;
use base 'Tab::DBI';
Tab::Judge->table('judge');
Tab::Judge->columns(Primary => qw/id/);
Tab::Judge->columns(Essential => qw/ code school active judge_group
								tournament first last uber timestamp score
								special notes prelim_pool neutral tmp gender
								cell first_year covers cfl_tab_first elim_group
								cfl_tab_second cfl_tab_third alt_group cfl_parl
								spare_pool paradigm novice trpc_string/);
Tab::Judge->columns(TEMP => qw/	qual regcode schname regcode panelid
								regid schid regname schcode 
								num_panels num_kids standby/);

Tab::Judge->has_a(school => 'Tab::School');
Tab::Judge->has_a(uber => 'Tab::Uber');
Tab::Judge->has_a(prelim_pool => 'Tab::Pool');
Tab::Judge->has_a(tournament => 'Tab::Tournament');
Tab::Judge->has_a(alt_group => 'Tab::JudgeGroup');
Tab::Judge->has_a(judge_group => 'Tab::JudgeGroup');
Tab::Judge->has_a(covers => 'Tab::JudgeGroup');

Tab::Judge->has_many(strikes => 'Tab::Strike', 'judge');
Tab::Judge->has_many(ballots => 'Tab::Ballot', 'judge');

Tab::Judge->has_many(elim_assigns => 'Tab::ElimAssign', 'judge');

Tab::Judge->set_sql(last_name => "select distinct judge.* from judge
									where judge.tournament = ? 
									and judge.last like ?");

Tab::Judge->set_sql(by_debate_round=> qq{select distinct judge.*
								from judge,panel,ballot
								where judge.id = ballot.judge
								and ballot.panel = panel.id
								and panel.round = ?
								order by judge.last});

Tab::Judge->set_sql(by_round=> qq{ select distinct judge.*,panel.id as panelid
								from judge,panel,ballot where judge.id = ballot.judge
								and ballot.panel = panel.id
								and panel.round = ?
								order by judge.code});

Tab::Judge->set_sql( by_uber_and_tourn => " 
					select distinct judge.* 
					from judge, school
					where judge.uber = ?
					and judge.school = school.id
					and school.tournament = ? ");

Tab::Judge->set_sql( duplicates => " 
						select distinct judge.id, duplicate.id
							from judge, judge as duplicate, 
							judge_group, judge_group as dup_group
							where judge_group.tournament = ?
							and dup_group.tournament = judge_group.tournament
							and judge.judge_group = judge_group.id
							and duplicate.judge_group = dup_group.id
							and duplicate.id > judge.id ");

Tab::Judge->set_sql( by_timeslot_and_site => " select distinct judge.*
						from judge,ballot,panel,round  
						where round.timeslot = ?
						and round.site = ?
						and panel.round = round.id 
						and ballot.panel = panel.id 
						and ballot.judge = judge.id");

Tab::Judge->set_sql( by_timeslot => " select distinct judge.*
						from judge,ballot,panel,round  
						where round.timeslot = ?
						and panel.round = round.id 
						and ballot.panel = panel.id 
						and ballot.judge = judge.id");

Tab::Judge->set_sql(highest_code => "select MAX(code) from judge where judge_group = ?");

Tab::Judge->set_sql(lowest_code => "select MIN(code) from judge where judge_group = ?");

Tab::Judge->set_sql(highest_pool_code => "select MAX(code) from judge where judge.prelim_pool = ? ");

Tab::Judge->set_sql(lowest_pool_code => "select MIN(code) from judge where judge.prelim_pool = ? ");

Tab::Judge->set_sql(count_by_group => "select count(distinct judge.id)
                       from judge
                       where judge.judge_group = ?
					");

Tab::Judge->set_sql(elim_by_group => "select distinct judge.* from judge,pool_group,pool_judge,pool
											where judge.judge_group = ? 
											and pool_judge.judge = judge.id
											and judge.judge_group = pool_group.judge_group
											and pool_group.pool = pool.id
											and pool.standby != 1
											and pool.prelim != 1
											and pool.id = pool_judge.pool");

Tab::Judge->set_sql(count_active_by_group => "select count(distinct judge.id)
                       	from judge
                      	where judge.judge_group = ?
						and judge.active = 1;
					");


Tab::Judge->set_sql(bypool => "select distinct judge.id from judge,pool_judge 
										where pool_judge.pool = ? 
										and pool_judge.judge = judge.id");

Tab::Judge->set_sql(by_pool_and_diocese => "select distinct judge.id 
											from judge,pool_judge,school
											where pool_judge.pool = ? 
											and pool_judge.judge = judge.id
											and judge.school = school.id
											and school.region = ?
											");

Tab::Judge->set_sql( by_group => "
        select distinct judge.*
            from judge,school,chapter
            where judge.judge_group = ?
			and judge.active = 1");

Tab::Judge->set_sql( hired_by_group => "
        select distinct judge.*, \"Hired\" as schname
            from judge where judge.judge_group = ?
			and spare_pool = 1");

Tab::Judge->set_sql( by_group_reg => "
        	select distinct judge.*, 
				school.name as schname, 
				region.name as regname,
				region.code as regcode,
				region.id as regid
            from judge,school,region
            where judge.judge_group = ?
			and judge.active = 1
            and school.id = judge.school
			and region.id = school.region
			");

Tab::Judge->set_sql(by_region => "select distinct judge.* 
									from judge force index(school), school
									where school.region = ?
									and school.tournament = ? 
									and judge.school = school.id
								");

Tab::Judge->set_sql(by_region_and_group => "select distinct judge.* 
									from judge force index(school), school
									where school.region = ?
									and judge.school = school.id
									and judge.judge_group = ? ");

Tab::Judge->set_sql(covers_by_region_and_group => "select distinct judge.* 
									from judge force index(school), school
									where school.region = ?
									and judge.school = school.id
									and judge.covers = ? ");


Tab::Judge->set_sql(by_region_and_alt_group => "select distinct judge.* 
									from judge force index(school), school
									where school.region = ?
									and judge.school = school.id
									and judge.alt_group = ? ");

Tab::Judge->set_sql(clean_for_pool => " 
    	select distinct judge.id,judge.school,judge.first,judge.last
		from judge,pool,timeslot
		where judge.active = 1
		and judge.tournament = pool.tournament

		and pool.id = ?
		and timeslot.id = pool.timeslot

        and not exists(
            select strike.id from strike
            where strike.judge = judge.id
            and strike.type = \"time\"
            and strike.start < timeslot.end
            and strike.end > timeslot.start
        )

        and not exists(
            select pool_judge.id from pool_judge, pool as p2, timeslot as t2
            where p2.timeslot = t2.id
            and timeslot.start < t2.end
            and timeslot.end > t2.start
            and pool_judge.judge = judge.id
            and pool_judge.pool = p2.id
        )

");

Tab::Judge->set_sql("delete_elims", "delete pool_judge.* from pool,pool_judge 
								where pool_judge.judge = ? 
								and pool_judge.pool = pool.id 
								and pool.standby != 1");

Tab::Judge->set_sql("delete_standby", "delete pool_judge.* from pool,pool_judge 
								where pool_judge.judge = ? 
								and pool_judge.pool = pool.id 
								and pool.standby = 1");


sub name { 
	my $self = shift;
	return $self->first." ".$self->last;
	# I AM LAZY!
}

sub schoolname { 
	my $self = shift;
	return $self->school->chapter->name;
}	

sub regionname { 
	my $self = shift;
	return $self->region->name;
}	

sub region { 
	my $self = shift;
	return $self->school->region;
}

sub standby_pools {
	my $self = shift;
	return Tab::Pool->search_by_standby_judge($self->id);
}

sub housing { 
	my ($self,$day) = @_;
	my @housings = Tab::Housing->search( judge => $self->id, night => $day->ymd) if $day;
	@housings = Tab::Housing->search( judge => $self->id) unless $day;
	return shift @housings;
}

sub pool_in { 
	my ($self, $timeslot) = @_;
	my @pools =  Tab::Pool->search_judge_and_timeslot($self->id, $timeslot->id);
	return $pools[0] if @pools;
	return;
}

sub panel_in { 
	my ($self, $timeslot) = @_;
	my @panels =  Tab::Panel->search_judge_and_timeslot($self->id, $timeslot->id);
	return $panels[0] if @panels;
	return;
}

sub is_busy_during { 
	my ($self, $timeslot) = @_;
	my @conflicts = Tab::Ballot->search_judge_busy_during($self->id, $timeslot->id);
	return 1 if @conflicts;
	return;
}

sub is_chair { 
	my ($self, $panel) = @_;

	my @chair_ballots = Tab::Ballot->search({  
					judge => $self->id, 
					panel => $panel->id,
					chair => 1 });

	return 1 if @chair_ballots;
	return;
}

sub pools {
	my $self = shift;
	return Tab::Pool->search_by_judge($self->id);
}

sub in_pool {
	my ($self, $pool) = @_;
	my @is_in = Tab::PoolJudge->search( pool => $pool->id, judge => $self->id );
	return unless @is_in;
	my $is = shift @is_in;
	return $is;
}

Tab::Judge->set_sql(not_ranked_by_event => "
		select distinct judge.id from judge,
		ballot,panel,comp,round
        where ballot.judge = judge.id
        and ballot.panel = panel.id
        and panel.round = round.id
        and round.timeslot = ?
		and round.event = ?
        and ballot.real_rank = 0
		and ballot.noshow = 0
        and ballot.comp = comp.id
        and comp.dropped = 0
        and comp.dq = 0" );

Tab::Judge->set_sql(not_ranked => "
		select distinct judge.id from judge,
		ballot,panel,comp,round
        where ballot.judge = judge.id
        and ballot.panel = panel.id
        and panel.round = round.id
        and round.timeslot = ?
        and ballot.real_rank = 0
		and ballot.noshow = 0
        and ballot.comp = comp.id
        and comp.dropped = 0
        and comp.dq = 0" );

Tab::Judge->set_sql(not_audited => "
		select distinct judge.id from judge,
		ballot,panel,comp,round
        where ballot.judge = judge.id
        and ballot.panel = panel.id
        and panel.round = round.id
        and round.timeslot = ?
        and ballot.audit = 0
		and ballot.real_rank > 0
		and ballot.noshow = 0
        and ballot.comp = comp.id
        and comp.dropped = 0
        and comp.dq = 0 ");

Tab::Judge->set_sql(not_audited_by_event => "
		select distinct judge.id from judge,
		ballot,panel,comp,round
        where ballot.judge = judge.id
        and ballot.panel = panel.id
        and panel.round = round.id
        and round.timeslot = ?
        and round.event = ?
        and ballot.audit = 0
		and ballot.real_rank > 0
		and ballot.noshow = 0
        and ballot.comp = comp.id
        and comp.dropped = 0
		and comp.dq = 0");

Tab::Judge->set_sql(has_seen => "select distinct judge.id from judge,ballot 
		where ballot.comp = ? and ballot.judge = judge.id");

Tab::Judge->set_sql(double_booked => "
   		select distinct judge.id
        from judge,
        panel as panel1,
        panel as panel2,
        ballot as ballot1,
        ballot as ballot2,
        round as round1,
        round as round2,
        timeslot as timeslot1,
        timeslot as timeslot2

        where judge.tournament = ?
        and ballot1.judge = judge.id
        and ballot2.judge = judge.id

        and ballot1.panel = panel1.id
        and panel1.round = round1.id
        and round1.timeslot = timeslot1.id

        and ballot2.panel = panel2.id
        and panel2.round = round2.id
        and round2.timeslot = timeslot2.id

        and timeslot1.start < timeslot2.end
        and timeslot1.end > timeslot2.start

        and panel1.id != panel2.id
	");

sub has_judged_event {
    my ($self, $event) = @_;
    my @ballots = Tab::Ballot->search_has_judged_event($self->id, $event->id);
	return @ballots;
}

Tab::Ballot->set_sql(has_judged_event => "select distinct ballot.id
						from ballot,comp 
						where ballot.judge = ? 
						and ballot.comp = comp.id
						and comp.event = ? ");

Tab::Judge->set_sql(by_panel => "select distinct judge.* 
			from judge,ballot 
			where ballot.panel= ? 
			and ballot.judge = judge.id ");

sub panels {
    my $self = shift;
    return Tab::Panel->search_by_judge($self->id);
}

Tab::Judge->set_sql(has_judged => qq{select distinct judge.id 
		from judge,ballot where ballot.comp= ? 
		and ballot.judge = judge.id });

sub has_judged {
    my $self = shift;
    return Tab::Comp->search_has_judged($self->id);
}

sub print_ratings {

	my ($self, $subset) = @_;

	my @ratings = Tab::Rating->search( judge => $self->id, subset => $subset->id, type => "coach" ) if $subset;
	@ratings = Tab::Rating->search( judge => $self->id, type => "coach") unless $subset;

	my $string;

	foreach my $rating (sort {$a->id cmp $b->id} @ratings) { 
		$string .= " ".$rating->qual->name if $rating->qual;
	}

	return $string;
}

sub rating { 

	my ($self, $subset) = @_;

	if ($subset) { 
		my @ratings = Tab::Rating->search( judge => $self->id, subset => $subset->id, type => "coach" );
		return shift @ratings if @ratings;
		return;
	} else { 
		my @ratings = Tab::Rating->search( judge => $self->id, type => "coach");
		return shift @ratings if @ratings;
		return;
	} 

}

sub all_ratings { 
	my $self = shift;
	my @ratings = Tab::Rating->search( judge => $self->id, type => "coach");
	return @ratings;
}

sub cannot_judge {
	my ($self,$comp) = @_;

	unless ($comp) {

		Tab::Comp->set_sql( cannot_see =>
			"(	select comp.id from comp,judge 
			  	where comp.school = judge.school 
			  	and judge.id = ".$self->id.")
	   			 		UNION
	    	 (	select comp.id from comp,ballot 
			  	where comp.id = ballot.comp 
			  	and ballot.judge = ".$self->id.")
	    				UNION
	    	 (	select comp from strike 
			  	where judge = ".$self->id.")
	    				UNION
	    	 (	select comp.id from comp,strike 
				where comp.school = strike.school 
				and judge = ".$self->id.")
			");
		return 	Tab::Comp->search_cannot_see;
	
	} else { 
		
		Tab::Comp->set_sql( cannot_judge =>
		"select distinct 1 from comp where ".$comp->id." in (

				select comp.id from comp,judge 
				where comp.school = judge.school 
				and judge.id = ".$self->id."
    		    		UNION
    			select comp.id from comp,ballot 
				where comp.id = ballot.comp 
				and ballot.judge = ".$self->id."
    		   			 UNION
    			select comp from strike 
				where judge = ".$self->id."
    		    		UNION
    			select comp.id from comp,strike 
				where comp.school = strike.school 
				and judge = ".$self->id."
			)" );

		return Tab::Comp->sql_cannot_judge->select_val;

	}

	return;

}

Tab::Judge->set_sql( usable_covers_judges =>"
				select distinct judge.* from judge
				where judge.school = ?
				and judge.covers = ?"
			);

Tab::Judge->set_sql( usable_judges =>"
				select distinct judge.* from judge
				where judge.school = ?
				and judge.judge_group = ?"
			);

Tab::Judge->set_sql( usable_judges_by_group =>"
				select distinct judge.* from judge
				where judge.judge_group = ?  "
				);

Tab::Judge->set_sql( useless_judges =>"
				select distinct judge.* from judge
				where judge.school = ?
				and judge.judge_group = ?
				"
				);

Tab::Judge->set_sql( by_school_and_bin => "
				select distinct judge.* from judge
				where judge.school = ?
				and judge_group = ? 
				and exists ( select strike.id from strike
					where strike.judge = judge.id
					and strike.bin = ? )");

Tab::Judge->set_sql( by_strikedness => "
				select distinct judge.* from judge,strike
				where judge.judge_group = ?
				and judge.id = strike.judge");

Tab::Judge->set_sql(housed => "select distinct judge.*
									from judge, housing
									where judge.school = ? 
									and judge.tournament = housing.tournament
									and judge.id = housing.judge");

sub setting {

	my ($self, $tag, $value, $blob) = @_;

	my @existing = Tab::JudgeSetting->search(  
		judge => $self->id,
		tag => $tag
	);

	if ($value && $value ne 0) { 

		if (@existing) {

			my $exists = shift @existing;
			$exists->value($value);
			$exists->value_text($blob) if $value eq "text";
			$exists->value_date($blob) if $value eq "date";
			$exists->update;

			foreach my $other (@existing) { 
				$other->delete;
			}

			return;

		} else {

			my $setting = Tab::JudgeSetting->create({
				judge => $self->id,
				tag => $tag,
				value => $value,
			});

			$setting->value_text($blob) if $value eq "text";
			$setting->value_date($blob) if $value eq "date";
			$setting->update;

		}

	} else {

		return unless @existing;

		my $setting = shift @existing;

		foreach my $other (@existing) { 
			$other->delete;
		}

		return $setting->text if $setting->value eq "text";
		return $setting->datetime if $setting->value eq "date";
		return $setting->value;

	}
}

