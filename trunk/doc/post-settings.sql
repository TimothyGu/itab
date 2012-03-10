create index tourn on changes(tourn);
create index panel on changes(panel);
create index entry on changes(entry);

alter table bin rename to strike_time;

alter table class rename to event_double;
create index tourn on event_double(tourn);

alter table comp rename to entry;
alter table housing rename to housing_student;
alter table item rename to concession;
alter table league rename to circuit;
alter table membership rename to circuit_membership;

alter table account_access rename to tourn_admin;
alter table league_admin rename to circuit_admin;
alter table chapter_access rename to chapter_admin;
alter table chapter_league rename to chapter_circuit;
alter table purchase rename to concession_purchase;
alter table qual rename to rating_tier;
alter table qual_subset rename to rating_subset;
alter table roomblock rename to room_strike;
alter table team_member rename to entry_student;

alter table follow_comp rename to follow_entry;
alter table ballot change comp entry int;
alter table changes change comp entry int;
alter table follow_comp change comp entry int;
alter table rating change comp entry int;
alter table strike change comp entry int;
alter table student_result change comp entry int;
alter table entry_student change comp entry int;


alter table chapter_circuit change league circuit int;
alter table due_payment change league circuit int;
alter table due_payment rename to circuit_dues;
alter table email change league circuit int;
alter table circuit_admin change league circuit int;
alter table circuit_chapter change league circuit int;
alter table news change league circuit int;
alter table region change league circuit int;
alter table site change league circuit int;

alter table concession_purchase change item concession int;

alter table rating change qual rating_tier int;
alter table rating_tier change qual_subset rating_subset int;
alter table rating add ordinal int;


drop table bill;
drop table sweep;
drop table flight;
drop table interest;
drop table account_interest;
drop table elim_assign;
drop table resultfile;
drop table method;
drop table schedule;
drop table link;
drop table news;
drop table setting;
drop table coach;

alter table uber rename to chapter_judge;

alter table tournament rename to tourn;
alter table tournament_site rename to tourn_site;
alter table fine rename to school_fine;
alter table changes rename to tourn_change;
alter table no_interest rename to account_ignore;

alter table account drop password;
alter table account drop active;
alter table account drop hotel;
alter table account drop saw_judgewarn;
alter table account drop change_deadline;
alter table account change change_timestamp password_timestamp datetime;
alter table account drop is_cell;
alter table account add provider varchar(63);
alter table account drop type;
alter table account add gender char;
alter table account add started date;
alter table account add paradigm text;

alter table ballot drop rank;
alter table ballot drop points;

alter table ballot change real_rank rank int;
alter table ballot change real_points points int;
alter table ballot drop flight;
alter table ballot drop rankinround;

alter table judge change uber chapter_judge int;
alter table event_double add min int;
alter table double_entry change setting tinyint;
alter table event change class event_double int;

alter table entry change code varchar(63);
alter table entry change apda_seed seed varchar(15);
alter table entry change registered_at reg_time datetime;
alter table entry change dropped_at drop_time datetime;

alter table entry drop tb0;
alter table entry drop tb1;
alter table entry drop tb2;
alter table entry drop tb3;
alter table entry drop tb4;
alter table entry drop tb5;
alter table entry drop tb6;
alter table entry drop tb7;
alter table entry drop tb8;
alter table entry drop tb9;
alter table entry drop results_bar;
alter table entry drop student;
alter table entry drop partner;
alter table entry drop dq_reason;
alter table entry drop doubled;
alter table entry drop housing;
alter table entry drop partner_housing;
alter table entry drop sweeps_points;
alter table entry drop noshow;
alter table entry drop qualifier;
alter table entry drop qualexp;
alter table entry drop qual2exp;
alter table entry drop qual2;
alter table entry drop wins;
alter table entry drop losses;
alter table entry drop initials;
alter table entry drop trpc_string;
alter table entry drop housing_start;
alter table entry drop housing_end;
alter table entry drop partner_housing_start;
alter table entry drop partner_housing_end;
alter table entry change tournament tourn int;

alter table rating change qual tier int;
alter table rating change rating_tier tier int;

alter table event_double drop judge_group;
alter table housing_student add account int;

alter table judge drop tourn;
alter table judge drop cfl_tab_first;
alter table judge drop cfl_tab_second;
alter table judge drop cfl_tab_third;
alter table judge drop alt_group;
alter table judge drop housing;
alter table judge drop gender;
alter table judge drop spare_pool;
alter table judge drop score;
alter table judge drop tournament;
alter table judge drop hire; 
alter table judge drop prelim_pool;
alter table judge drop cell;
alter table judge drop first_year;
alter table judge drop paradigm;
alter table judge drop novice;
alter table judge drop trpc_string;
alter table judge add account int;
alter table judge change uber chapter_judge int;

alter table judge drop neutral;
alter table judge drop tmp;
alter table judge add hired int;

alter table judge_group drop missing_judge_fee;
alter table judge_group drop reduce_alt_burden;
alter table judge_group drop uncovered_entry_fee;
alter table judge_group drop track_by_pools;
alter table judge_group drop alt_max;
alter table judge_group drop min_burden;
alter table judge_group drop max_burden;
alter table judge_group drop default_alt_reduce;
alter table judge_group drop ask_paradigm;
alter table judge_group drop strikes_explain;
alter table judge_group drop conflicts;
alter table judge_group drop paradigm_explain;
alter table judge_group drop fee_missing;
alter table judge_group drop pub_assigns;
alter table judge_group drop dio_min;
alter table judge_group drop ask_alts;
alter table judge_group drop free;
alter table judge_group drop collective;
alter table judge_group drop school_strikes;
alter table judge_group drop strike_reg_opens;
alter table judge_group drop strike_reg_closes;
alter table judge_group drop max_pool_burden;
alter table judge_group drop track_judge_hires;
alter table judge_group drop hired_fee;
alter table judge_group drop hired_pool;
alter table judge_group drop cumulate_mjp;
alter table judge_group drop special;
alter table judge_group drop elim_special;
alter table judge_group drop tab_room;
alter table judge_group drop live_updates;
alter table judge_group drop ratings_need_paradigms;
alter table judge_group drop ratings_need_entry;
alter table judge_group drop strikes_need_paradigms;
alter table judge_group drop strikes_need_entry;
alter table judge_group drop obligation_before_strikes;
alter table judge_group drop coach_ratings;
alter table judge_group drop school_ratings;
alter table judge_group drop comp_ratings;
alter table judge_group drop comp_strikes;
alter table judge_group drop group_max;

alter table judge_group change tournament tourn int;


